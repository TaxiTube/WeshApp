//
//  WDeleteButton.swift
//  WeshApp
//
//  Created by rabzu on 07/04/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class WDeleteButton: WCellButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func drawRect(rect: CGRect) {
        WDeleteSK.drawDeleteChannelBtnCanvas(frame: rect, deleteBtnClicked: isPressed, deleteBtnNotClicked: !isPressed)
    }


}
