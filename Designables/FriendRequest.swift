//
//  FriendRequest.swift
//  WeshApp
//
//  Created by rabzu on 14/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class FriendRequest: UIView, UIGestureRecognizerDelegate {

    var isPressed: Bool = false
    
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let recognizer = UILongPressGestureRecognizer (target: self, action:Selector("handleTap:"))
        recognizer.minimumPressDuration = 0.01
        recognizer.delegate = self
        
        self.addGestureRecognizer(recognizer)
    }

  
    public override func drawRect(rect: CGRect) {
            WeshappFriendRequestSK.drawFriendCanvas(friendFrame: bounds, sendMsgBtnClicked: isPressed)
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
