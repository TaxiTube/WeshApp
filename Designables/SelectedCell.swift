//
//  SelectedCell.swift
//  WeshApp
//
//  Created by rabzu on 12/03/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

class SelectedCell: UIView, UIGestureRecognizerDelegate {
    var isPressed: Bool = false

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let recognizer = UILongPressGestureRecognizer (target: self, action:Selector("handleTap:"))
        recognizer.minimumPressDuration = 0.2
        recognizer.delegate = self
        
       // self.addGestureRecognizer(recognizer)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        WeshappSelectedCellSK.drawSelectedCell(frame: frame, btnClicked: isPressed, notClicked: !isPressed)
    }
    
    func handleTap(recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state  == UIGestureRecognizerState.Began{
            
            isPressed = true
        }else if recognizer.state  == UIGestureRecognizerState.Ended{
            isPressed = false
            
        }
        
        setNeedsDisplay()
    }

    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return false
    }

  
}
