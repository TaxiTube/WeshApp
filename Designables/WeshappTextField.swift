//
//  WeshappTextField.swift
//  WeshApp
//
//  Created by Zuka on 1/18/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable public class WeshappTextField: UITextField{
    
    //@IBInspectable public var borderColor: UIColor = UIColor.whiteColor()
    public  override func drawRect(rect: CGRect){
        self.layer.borderColor = UIColor.blueColor().CGColor
    }
}
 