//
//  MsgIcon.swift
//  WeshApp
//
//  Created by rabzu on 14/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class MsgIcon: WCellButton {
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(rect: CGRect) {
        WeshappMsgIconSK.drawMsgCanvas(msgFrame: bounds, sendMsgBtnClicked: isPressed)
    }

 
}
