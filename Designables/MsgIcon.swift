//
//  MsgIcon.swift
//  WeshApp
//
//  Created by rabzu on 14/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class MsgIcon: UIView {
    var isPressed = false
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func drawRect(rect: CGRect) {
        WeshappMsgIconSK.drawMsgCanvas(msgFrame: bounds, sendMsgBtnClicked: isPressed)
    }

   
    public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        isPressed = true
        setNeedsDisplay()
    }
    public override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        isPressed = false
        setNeedsDisplay()
    }
    public override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
        isPressed = false
        setNeedsDisplay()
    }
}
