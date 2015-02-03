//
//  WeshappNavBar.swift
//  WeshApp
//
//  Created by Zuka on 1/25/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
public class WeshappNavBar: UINavigationBar{
    
    let proportion: CGFloat = 0.094
    
    
    public override init(frame: CGRect){
        let screenSize  = UIScreen.mainScreen().bounds.size
        super.init(frame: frame)
        setUp()
    }
    
     
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        
    }
    func setUp(){
        let screenSize  = UIScreen.mainScreen().bounds.size
        
        frame = CGRectMake(0.0, 0.0, screenSize.width, screenSize.height * proportion)
      //  barStyle     = UIBarStyle.BlackTranslucent
        //Removes nav bar 1 px shadow
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        //translucent = true
        //opaque = true
        
        backgroundColor =  UIColorFromRGB(0x51c1d2)
        barTintColor = UIColorFromRGB(0x51c1d2)
        tintColor = UIColorFromRGB(0xffffff)
        
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                  NSFontAttributeName: font ]
        titleTextAttributes = titleDict
       // self.setTitleVerticalPositionAdjustment(-10.9, forBarMetrics: UIBarMetrics.Default)
        
      /*
        let stView = UIView()
        stView.setTranslatesAutoresizingMaskIntoConstraints(false)
        // stView.intrinsicContentSize()
        stView.backgroundColor = UIColorFromRGB(0x51c1d2)
        let viewsDictionary = ["statusBar": stView]
       // stView.
        self.addSubview(stView)
        
        self.layoutMargins = UIEdgeInsetsZero
        //Margin constraints
      //  let hConstraints: NSArray =  NSLayoutConstraint.constraintsWithVisualFormat("H:|-[statusBar]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
       // let vConstraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[statusBar]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        
        let heightConstraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[statusBar(20)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        
       // self.addConstraint(NSLayoutConstraint(item: stView,
        //attribute: .Height, relatedBy: .Equal, toItem: self,
        //attribute: .Height, multiplier: 5, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: stView,
            attribute: .Width, relatedBy: .Equal, toItem: self,
            attribute: .Width, multiplier: 1, constant: 0))
     //   self.addConstraints(hConstraints)
      // self.addConstraints(vConstraints)
        self.addConstraints(heightConstraints)
        
        */

    }
    public override func layoutSubviews() {
        super.layoutSubviews()
     //  self.backItem?.leftBarButtonItem?.
//        topItem?.prompt=""

    }
    
    
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
