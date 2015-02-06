//
//  WeshappRedButton.swift
//  WeshApp
//
//  Created by Zuka on 1/20/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable
public class WeshappRedButton: UIView {
    var isPressed:Bool = false
    
  
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        WeshappRedButtonSK.drawDrawRedButton(redButtonFrame: bounds, btnClicked: isPressed)
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
