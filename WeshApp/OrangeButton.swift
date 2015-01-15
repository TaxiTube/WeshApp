//
//  OrangeButton.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//



import UIKit

@IBDesignable
public class OrangeButton: UIButton{
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
  public  override func drawRect(rect: CGRect){
    
     self.layer.backgroundColor =  UIColorFromRGB(0xf07269).CGColor
     self.layer.cornerRadius = 5


    
    }
}
