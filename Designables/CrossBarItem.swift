//
//  CrossBarItem.swift
//  WeshApp
//
//  Created by rabzu on 22/01/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable
public class CrossBarItem: UIView {
    
    var isPressed:Bool = false
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func drawRect(rect: CGRect) {
        CrossIconSK.drawCanvas1(frame: bounds, whiteBool: isPressed, tintBool: isPressed)
    
    
    }
    public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        isPressed = true
        setNeedsDisplay()
    }
   public override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        isPressed = false
        setNeedsDisplay()
    }

}
