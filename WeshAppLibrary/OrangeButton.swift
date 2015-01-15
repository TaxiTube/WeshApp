//
//  OrangeButton.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//



import UIKit

@IBDesignable
class OrangeButton: UIButton{
    
    override func drawRect(rect: CGRect){
    
     self.layer.backgroundColor =  AppDelegate.UIColorFromRGB(0xf07269).CGColor
     self.layer.cornerRadius = 5


    
    }
}
