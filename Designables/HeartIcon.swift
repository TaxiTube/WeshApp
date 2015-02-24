//
//  HeartIcon.swift
//  WeshApp
//
//  Created by rabzu on 23/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class HeartIcon: UIView, UIGestureRecognizerDelegate {

      var isPressed  = false
    override public func drawRect(rect: CGRect) {
        
        
        WeshappHeartSK.drawHearIcon(frame: rect, hrtActive: isPressed, hrtInactive: !isPressed)
        let recognizer = UILongPressGestureRecognizer (target: self, action:Selector("handleTap:"))
        recognizer.minimumPressDuration = 0.01
        recognizer.delegate = self
    }
    
    public func handleTap(recognizer: UILongPressGestureRecognizer) {
        
        println("heartshou")
        if recognizer.state  == UIGestureRecognizerState.Began{
            
            isPressed = true
        }else if recognizer.state  == UIGestureRecognizerState.Ended{
            isPressed = false
        }
        setNeedsDisplay()
    }


}
