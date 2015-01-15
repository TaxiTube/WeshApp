//
//  TextFieldSendView.swift
//  WeshApp
//
//  Created by z.kakabadze on 26/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable
public class TextViewSendView: UIView{
    
    
   public override func drawRect(rect: CGRect){
        let grey80 = UIColor(white:0.80, alpha:1)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = grey80.CGColor
        
    }
    
}