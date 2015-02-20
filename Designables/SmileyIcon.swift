//
//  SmileyIcon.swift
//  WeshApp
//
//  Created by rabzu on 20/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class SmileyIcon: UIView, UIGestureRecognizerDelegate {
    
    var isPressed = false
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let recognizer = UILongPressGestureRecognizer (target: self, action:Selector("handleTap:"))
        recognizer.minimumPressDuration = 0.01
        recognizer.delegate = self
        
        self.addGestureRecognizer(recognizer)
    }
    public override func drawRect(rect: CGRect) {
       WeshappSmileIconSK.drawSmileyIcon(frame: rect, smlClicked: isPressed, smlNotClicked: !isPressed)
    }
    
    public  func handleTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state  == UIGestureRecognizerState.Began{
            
            isPressed = true
        }else if recognizer.state  == UIGestureRecognizerState.Ended{
            isPressed = false
        }
        setNeedsDisplay()
    }


}
