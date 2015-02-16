//
//  BorderView.swift
//  WeshApp
//
//  Created by rabzu on 16/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable
class BorderView: UIView {
    
    @IBInspectable let top: Bool = false
    @IBInspectable var bottom: Bool = false
    @IBInspectable var left: Bool = false
    @IBInspectable var right: Bool = false
    
    @IBInspectable var lineWidth: CGFloat = 0.0
    
    
    override func drawRect(rect:CGRect) {
        let grey80 = UIColor(white:0.80, alpha:1)
        
        let context = UIGraphicsGetCurrentContext()
    
        if top {
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
        }
        
        if bottom{
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        }
        
        if left{
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        }
        
        if right{
            CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        }
        
        
        CGContextSetStrokeColorWithColor(context, grey80.CGColor)
        CGContextSetLineWidth(context, 1.0);
        CGContextStrokePath(context);
    }
}
