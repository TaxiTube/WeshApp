//
//  WeshappNavBar.swift
//  WeshApp
//
//  Created by Zuka on 1/25/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
@IBDesignable public
class WeshappNavBar: UINavigationBar {


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func drawRect(rect: CGRect) {
        
       
        
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        backgroundColor =  UIColorFromRGB(0x51c1d2)
        barTintColor = UIColorFromRGB(0x51c1d2)
        tintColor = UIColorFromRGB(0xffffff)
        
        
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: font ]
        titleTextAttributes = titleDict
        
        // let screenSize  = UIScreen.mainScreen().bounds.size
        frame = CGRectMake(0.0, 0.0, 320, 70);

        
    }
   
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        let newSize = CGSizeMake(320,70);
        //frame = CGRectMake(0.0, 0.0, 320, 70);
        return newSize;
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
