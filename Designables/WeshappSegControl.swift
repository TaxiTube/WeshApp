//
//  WeshappSegControl.swift
//  WeshApp
//
//  Created by rabzu on 29/01/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

public class WeshappSegControl: UISegmentedControl {
    
    public override init(frame: CGRect){
     super.init(frame: frame)
    }
    
    required public init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        var font = UIFont(name: "TitilliumText25L-250wt", size: 15.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                  NSFontAttributeName: font ]

        setTitleTextAttributes(titleDict, forState: UIControlState.Selected)
       
        font = UIFont(name: "TitilliumText25L-250wt", size: 15.0)!
        setTitleTextAttributes([NSFontAttributeName: font ], forState: UIControlState.Normal)

        
        var segRight = self.subviews[0] as UIView
        var segLeft = self.subviews[1] as UIView
        segLeft.tintColor = UIColorFromRGB(0xff5959)
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    public override func didChangeValueForKey(key: String) {
        let subviews = self.subviews
        var segLeft = subviews[1] as UIView
        var segRight = subviews[0] as UIView
        
        let selectedColour = UIColorFromRGB(0xff5959)
        switch self.selectedSegmentIndex{
            case 0:
                segLeft.tintColor = selectedColour
                segRight.tintColor =  UIColor.whiteColor()
            case 1:
                segRight.tintColor = selectedColour
                segLeft.tintColor =  UIColor.whiteColor()
            default: break
        }
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
