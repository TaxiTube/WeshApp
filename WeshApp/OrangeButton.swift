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
    
  

   public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // setTranslatesAutoresizingMaskIntoConstraints(false)
    }


  public  override func drawRect(rect: CGRect){
    layer.backgroundColor =  UIColorFromRGB(0xff5959).CGColor
    layer.cornerRadius = 2
    titleLabel?.font =  UIFont(name: "TitilliumText25L-250wt", size: 15.0)!
    tintColor = UIColor.whiteColor()
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
