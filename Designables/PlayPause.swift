//
//  PlayPause.swift
//  WeshApp
//
//  Created by rabzu on 14/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class PlayPause: UIView, UIGestureRecognizerDelegate {
    
      var isPlay: Bool = false
      var isPlayPressed: Bool = false
      var isPausePressed: Bool = false
      var isPause: Bool = true
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let recognizer = UILongPressGestureRecognizer (target: self, action:Selector("handleTap:"))
        recognizer.minimumPressDuration = 0.01
        recognizer.delegate = self
        
        self.addGestureRecognizer(recognizer)
    }
    override public func drawRect(rect: CGRect) {
        WeshappPlayPauseSK.drawPlayPauseBtnCanvas(frame: rect,
                                               pauseBtn: isPause,
                                        pauseBtnClicked: isPausePressed,
                                                playBtn: isPlay,
                                         playBtnClicked: isPlayPressed)
    }
    
    
    public  func handleTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state  == UIGestureRecognizerState.Began{
            if isPause {
                isPausePressed = true
                isPause = false
            }else if isPlay{
                isPlayPressed = true
                isPlay = false
            }
        }else if recognizer.state  == UIGestureRecognizerState.Ended{
            if isPausePressed {
                isPausePressed = false
                isPlay = true
            
            } else if isPlayPressed{
                isPlayPressed = false
                isPause = true
            }
        }
        setNeedsDisplay()
    }
    
}
