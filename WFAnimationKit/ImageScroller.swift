//
//  ImageScroller.swift
//  Club W App
//
//  Created by Whitney Foster on 6/18/15.
//  Copyright (c) 2015 WhitneyFoster. All rights reserved.
//

import UIKit
import Foundation

class PageDot: UIView {
    private var primaryColor: UIColor!
    private var secondaryColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, primaryColor: UIColor, secondaryColor: UIColor) {
        super.init(frame: frame)
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.deselectDot()
    }
    
    func selectDot() {
        self.backgroundColor = primaryColor
    }
    
    func deselectDot() {
        self.backgroundColor = secondaryColor
    }
}

class PageDotController: UIView {
    private var dots: NSMutableArray = NSMutableArray()
    private var selectedPage: Int = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, pageCount: Int, primaryColor: UIColor, secondaryColor: UIColor) {
        super.init(frame: frame)
        var x = (UIScreen.mainScreen().bounds.width - CGFloat(pageCount) - CGFloat(pageCount)*8)/2
        for var i=0; i<=(pageCount-1); i++ {
            addPage(x, primaryColor: primaryColor, secondaryColor: secondaryColor)
            x += 8
        }
    }
    
    private func addPage(x: CGFloat, primaryColor: UIColor, secondaryColor: UIColor) {
        var dot = PageDot(frame: CGRectMake(x, 0, 5, 5), primaryColor: primaryColor, secondaryColor: secondaryColor)
        if dots.count == 0 {
            dot.selectDot()
            selectedPage = 0
        }
        dots.addObject(dot)
        self.addSubview(dot)
        dot.setNeedsDisplay()
    }
    
    func forwardPage() -> Bool {
        if selectedPage != (dots.count-1) {
            dots[selectedPage].deselectDot()
            selectedPage++
            dots[selectedPage].selectDot()
            return true
        }
        return false
    }
    
    func backwardPage() -> Bool {
        if selectedPage != 0 {
            dots[selectedPage].deselectDot()
            selectedPage--
            dots[selectedPage].selectDot()
            return true
        }
        return false
    }
}

class ImageScroller: UIView {
    private var images: NSMutableArray = NSMutableArray()
    private var pageControl: PageDotController!
    private var selectedPage: Int = 0
    var primaryColor: UIColor
    var secondaryColor: UIColor
    
    required init(frame: CGRect, primaryColor: UIColor, secondaryColor: UIColor) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.primaryColor = UIColor.blackColor()
        self.secondaryColor = UIColor.grayColor()
        super.init(coder: aDecoder)
    }
    
    internal func panView(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            if sender.translationInView(self).x < 50 {
                self.scrollForward()
            }
            else if sender.translationInView(self).x > 50 {
                self.scrollBackward()
            }
        }
    }
    
    func setImage(image: UIImage?) { // you will only have one page this way (I might make it mutable later)
        var holder: UIImageView = UIImageView(image: image)
        holder.frame = CGRectMake(self.frame.width * CGFloat(images.count), 0, self.frame.width, self.frame.height)
        images.addObject(holder)
        self.addSubview(holder)
        pageControl = PageDotController(frame: CGRectMake(0, self.frame.height - 15, self.frame.width, 5), pageCount: images.count, primaryColor: primaryColor, secondaryColor: secondaryColor)
        self.addSubview(pageControl)
        pageControl.setNeedsDisplay()
        selectedPage = 0
        var gr = UIPanGestureRecognizer(target: self, action: "panView:")
        self.addGestureRecognizer(gr)
    }
    
    func setImages(imageArray: NSArray) {
        for image in imageArray {
            var holder: UIImageView = UIImageView(image: image as! UIImage)
            holder.frame = CGRectMake(self.frame.width * CGFloat(images.count), 0, self.frame.width, self.frame.height)
            images.addObject(holder)
            self.addSubview(holder)
        }
        pageControl = PageDotController(frame: CGRectMake(0, self.frame.height - 15, self.frame.width, 5), pageCount: imageArray.count, primaryColor: primaryColor, secondaryColor: secondaryColor)
        self.addSubview(pageControl)
        pageControl.setNeedsDisplay()
        selectedPage = 0
        var gr = UIPanGestureRecognizer(target: self, action: "panView:")
        self.addGestureRecognizer(gr)
    }
    
    private func resetImage() {
        var currentPage = images[selectedPage] as? UIImageView
        var previousPage: UIImageView?
        var framePrevious: CGRect?
        var nextPage: UIImageView?
        var frameNext: CGRect?
        var frameCurrent = currentPage?.frame
        frameCurrent?.origin.x = 0
        if selectedPage != images.count-1 {
            nextPage = images[selectedPage+1] as? UIImageView
            frameNext = nextPage?.frame
            frameNext?.origin.x = frameCurrent!.origin.x + frameCurrent!.width
        }
        if selectedPage != 0 {
            previousPage = images[selectedPage-1] as? UIImageView
            framePrevious = previousPage?.frame
            framePrevious?.origin.x = -UIScreen.mainScreen().bounds.width
        }
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            currentPage?.frame = frameCurrent!
            previousPage?.frame = framePrevious!
            nextPage?.frame = frameNext!
            }, completion: nil)
    }
    
    private func scrollForwardToPostion(x: CGFloat) {
        var currentPage = images[selectedPage] as? UIImageView
        if selectedPage != images.count-1 {
            var nextPage = images[selectedPage+1] as? UIImageView
            var frameCurrent = currentPage?.frame
            var frameNext = nextPage?.frame
            nextPage?.frame.origin.x = frameCurrent!.origin.x + frameCurrent!.width
            frameCurrent?.origin.x = x
            frameNext?.origin.x = frameCurrent!.origin.x + frameCurrent!.width
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                currentPage?.frame = frameCurrent!
                nextPage?.frame = frameNext!
                }, completion: nil)
        }
    }
    
    private func scrollBackwardToPostion(x: CGFloat) {
        var currentPage = images[selectedPage] as? UIImageView
        if selectedPage != 0 {
            var previousPage = images[selectedPage-1] as? UIImageView
            var frameCurrent = currentPage?.frame
            var framePrevious = previousPage?.frame
            frameCurrent?.origin.x = x
            framePrevious?.origin.x = 0
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                currentPage?.frame = frameCurrent!
                previousPage?.frame = framePrevious!
                }, completion: nil)
        }
    }
    
    func scrollForward() {
        var result = pageControl.forwardPage()
        if result == true {
            scrollForwardToPostion(-UIScreen.mainScreen().bounds.width)
            selectedPage++
        }
    }
    
    func scrollBackward() {
        var result = pageControl.backwardPage()
        if result == true {
            scrollBackwardToPostion(UIScreen.mainScreen().bounds.width)
            selectedPage--
        }
    }
    
    
    
}
