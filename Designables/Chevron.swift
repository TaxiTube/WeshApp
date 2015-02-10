//
//  Chevron.swift
//  WeshApp
//
//  Created by rabzu on 08/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
@IBDesignable
public class Chevron: UIView {


    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

   public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func drawRect(rect: CGRect) {
        WeshappChevronSK.drawChevronCanvas(chevronFrame: rect)
    }


}
