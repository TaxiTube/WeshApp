//
//  WeshappNavBar.swift
//  WeshApp
//
//  Created by Zuka on 1/25/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
public class WeshappNavBar: UINavigationBar{
    let proportion: CGFloat = 0.083
    
     public override init(frame: CGRect){
        let screenSize  = UIScreen.mainScreen().bounds.size
        super.init(frame: frame)

        
        self.frame = CGRectMake(0.0, 0.0, screenSize.width, screenSize.height * proportion)
        
          //Removes nav bar 1 px shadow
         shadowImage = UIImage()
         setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)

        backgroundColor =  UIColorFromRGB(0x51c1d2)
        barTintColor = UIColorFromRGB(0x51c1d2)
        tintColor = UIColorFromRGB(0xffffff)
        
        
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: font ]
        titleTextAttributes = titleDict
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //barStyle = UIBarStyle.Black
        //translucent = true
        let screenSize  = UIScreen.mainScreen().bounds.size

        frame = CGRectMake(0.0, 0.0, screenSize.width, screenSize.height * proportion)
        
        //Removes nav bar 1 px shadow
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        backgroundColor =  UIColorFromRGB(0x51c1d2)
       barTintColor = UIColorFromRGB(0x51c1d2)
        tintColor = UIColorFromRGB(0xffffff)
        
        
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                  NSFontAttributeName: font ]
        titleTextAttributes = titleDict
        
    }
    

   
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        
        let screenSize  = UIScreen.mainScreen().bounds.size
        let newSize = CGSizeMake(screenSize.width, screenSize.height * proportion )
        
        return newSize
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
