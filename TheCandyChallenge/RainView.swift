//
//  RainView.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 13/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation
import UIKit

class RainView: UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let maxStartingWidth = Int(rect.width)
        let xStart = CGFloat(Int.random(5...maxStartingWidth))
        let yStart = CGFloat(-15)

        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 1.5)
        CGContextMoveToPoint(context, xStart, yStart)
        CGContextAddLineToPoint(context, xStart, yStart + 30)
        CGContextDrawPath(context, kCGPathStroke)
    }
}


extension Int {
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}
