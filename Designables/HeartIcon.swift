//
//  HeartIcon.swift
//  WeshApp
//
//  Created by rabzu on 23/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
//TODO: Implement heart icon delegate to send like
public class HeartIcon: UIView, UIGestureRecognizerDelegate {

    var isPressed  = false
    override public func drawRect(rect: CGRect) {
        
        
        WeshappHeartSK.drawHearIcon(frame: rect, hrtActive: isPressed, hrtInactive: !isPressed)
        let recognizer = UITapGestureRecognizer (target: self, action:Selector("handleTap:"))

        recognizer.delegate = self
        self.addGestureRecognizer(recognizer)

    }
    
    public func handleTap(recognizer: UILongPressGestureRecognizer) {
        
        isPressed = !isPressed
        setNeedsDisplay()
    }


}
