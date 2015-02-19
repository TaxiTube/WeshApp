//
//  WeshappRedButton.swift
//  WeshApp
//
//  Created by Zuka on 1/20/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable
public class WeshappRedButton: UIView, UIGestureRecognizerDelegate {
    var isPressed:Bool = false
    
  
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let recognizer = UILongPressGestureRecognizer (target: self, action:Selector("handleTap:"))
        recognizer.minimumPressDuration = 0.01
        recognizer.delegate = self

        self.addGestureRecognizer(recognizer)
    }
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        WeshappRedButtonSK.drawRedArrowCanvas(buttonFrame: rect, btnClicked: isPressed, notClicked: !isPressed)
    }
    


    public  func handleTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state  == UIGestureRecognizerState.Began{
            
            isPressed = true
        }else if recognizer.state  == UIGestureRecognizerState.Ended{
            isPressed = false
        }
        
        println("hadn \(recognizer.state.rawValue)")
        setNeedsDisplay()
    }
//   
//    public override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        isPressed = false
//        setNeedsDisplay()   
//    }
//    
   
}
