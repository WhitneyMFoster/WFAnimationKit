//
//  WFAnimationObject.swift
//  WFAnimationKit
//
//  Created by Whitney Foster on 6/2/15.
//  Copyright (c) 2015 WhitneyFoster. All rights reserved.
//

import Foundation

enum WFDirection {
    case right, left, up, down
}

class Location {
    var x: CGFloat?
    var y: CGFloat?
    init(x: CGFloat, y:CGFloat) {
        self.x = x;
        self.y = y;
    }
}

class WFAnimationObject: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func slide(direction:WFDirection, duration:NSTimeInterval, destination:Location) {
        let origin = Location(x: self.frame.origin.x, y: self.frame.origin.y)
        let width = self.frame.width
        let height = self.frame.height

        switch direction {
        case WFDirection.left:
            self.frame = CGRectMake(UIScreen.mainScreen().bounds.width, origin.y!, width, height)
            break
        case WFDirection.right:
            self.frame = CGRectMake(-1 * width, origin.y!, width, height)
            break
        case WFDirection.up:
            self.frame = CGRectMake(origin.x!, UIScreen.mainScreen().bounds.height, width, height)
            break
        case WFDirection.down:
            self.frame = CGRectMake(origin.x!, -1 * height, width, height)
            break
        default:
            break
        }
        UIView.animateWithDuration(duration, animations: {
            self.frame = CGRectMake(destination.x!, destination.y!, width, height)
        })
    }

    func slideZoom(direction:WFDirection, duration:NSTimeInterval, destination:Location, scale: CGFloat) {
        let origin = Location(x: self.frame.origin.x, y: self.frame.origin.y)
        let width = self.frame.width
        let height = self.frame.height
        
        switch direction {
        case WFDirection.left:
            self.frame = CGRectMake(UIScreen.mainScreen().bounds.width, origin.y! + scale, width - scale, height - scale)
            break
        case WFDirection.right:
            self.frame = CGRectMake(-1 * width, origin.y! + scale, width - scale, height - scale)
            break
        case WFDirection.up:
            self.frame = CGRectMake(origin.x! + scale, UIScreen.mainScreen().bounds.height + scale, width - scale, height - scale)
            break
        case WFDirection.down:
            self.frame = CGRectMake(origin.x! + scale, -1 * height, width - scale, height - scale)
            break
        default:
            break
        }
        UIView.animateWithDuration(duration, animations: {
            self.frame = CGRectMake(destination.x!, destination.y!, width, height)
        })
    }
    
    func PopUp(scale: CGFloat, duration:NSTimeInterval) {
        let origin = Location(x: self.frame.origin.x, y: self.frame.origin.y)
        let width = self.frame.width
        let height = self.frame.height
        
        self.frame = CGRectMake(origin.x! + scale, origin.y! + scale, width - scale, height - scale)
        
        UIView.animateWithDuration(duration, animations: {
            self.frame = CGRectMake(origin.x!, origin.y!, width, height)
        })
    }

    func PopDown(scale: CGFloat, duration:NSTimeInterval) {
        let origin = Location(x: self.frame.origin.x, y: self.frame.origin.y)
        let width = self.frame.width
        let height = self.frame.height
        
        self.frame = CGRectMake(origin.x! - scale, origin.y! - scale, width + scale, height + scale)
        
        UIView.animateWithDuration(duration, animations: {
            self.frame = CGRectMake(origin.x!, origin.y!, width, height)
        })
    }

    
}