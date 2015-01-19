//
//  WeshappRedButton.swift
//  WeshApp
//
//  Created by Zuka on 1/20/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable
public class WeshappRedButton: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        WeshappStyleKit.drawCanvas1(frame2: self.bounds)
    }
    

}
