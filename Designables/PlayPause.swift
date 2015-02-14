//
//  PlayPause.swift
//  WeshApp
//
//  Created by rabzu on 14/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class PlayPause: UIView {
    
      var isPlayPressed: Bool = false
      var isPausePressed: Bool = false
      var isPause: Bool = true
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        WeshappPlayPauseSK.drawPauseCanvas(frame: bounds,
                                  playBtnClicked: isPlayPressed,
                                 pauseBtnClicked: isPausePressed,
                                    channelState: !isPause )
    }
    
 public override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {

        if isPause {
            isPausePressed = false
        }else{
            isPlayPressed = false
        }
        isPause = !isPause
        setNeedsDisplay()
    }

    
    public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if isPause {
            isPausePressed = true
        }else{
            isPlayPressed = true
        }
        setNeedsDisplay()
    }
    public override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if isPause {
            isPausePressed = false
        }else{
            isPlayPressed = false
        }
        isPause = !isPause
        setNeedsDisplay()
    }
    


}
