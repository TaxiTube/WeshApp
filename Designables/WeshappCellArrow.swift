//
//  WeshappCellArrow.swift
//  WeshApp
//
//  Created by rabzu on 07/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class WeshappCellArrow: UIView {

  public  override init(frame: CGRect) {
        super.init(frame: frame)
    }

   public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        WeshappListArrowSK.drawLinkArrowCanvas(arrowFrame: rect)
    
    }
   
}
