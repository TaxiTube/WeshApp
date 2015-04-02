//
//  WClockIcon.swift
//  WeshApp
//
//  Created by rabzu on 02/04/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class WClockIcon: UIView {

    var isActive = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
         self.backgroundColor = UIColor.clearColor()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         self.backgroundColor = UIColor.clearColor()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        WClockIconSK.drawClock(frame: rect, clockInactive: !isActive, clockActive: isActive)
    }
    
    func setActive(active: Bool){
        self.isActive = active
        setNeedsDisplay()
    }


}
