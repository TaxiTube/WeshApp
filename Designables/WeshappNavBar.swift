//
//  WeshappNavBar.swift
//  WeshApp
//
//  Created by Zuka on 1/25/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
public class WeshappNavBar: UINavigationBar{
    
    let proportion: CGFloat = 0.095
    
    
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
        
        //ADD STATUS BAR VIEW
        let stView = UIView()
        stView.setTranslatesAutoresizingMaskIntoConstraints(false)
        stView.intrinsicContentSize()
        stView.backgroundColor = UIColorFromRGB(0x51c1d2)
        let viewsDictionary = ["statusBar": stView]
        self.addSubview(stView)
        self.layoutMargins = UIEdgeInsetsZero
        //Margin constraints
        
        
        
//        var topConstraint = NSLayoutConstraint(item: stView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0 )
     
        var topConstraint = NSLayoutConstraint(item: stView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0  )
        
        var leftConstraint = NSLayoutConstraint(item: stView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0  )
        
        
        var rightConstraint = NSLayoutConstraint(item: stView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0  )
        
        
        var heightC = NSLayoutConstraint(item: stView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
//        let heightConstraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[statusBar(20)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        
        // self.addConstraint(NSLayoutConstraint(item: stView,
        //attribute: .Height, relatedBy: .Equal, toItem: self,
        //attribute: .Height, multiplier: 5, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: stView,
//            attribute: .Width, relatedBy: .Equal, toItem: self,
//            attribute: .Width, multiplier: 1, constant: 0))
        self.addConstraint(topConstraint)
        self.addConstraint(leftConstraint)
        self.addConstraint(rightConstraint)

        self.addConstraint(heightC)
        self.layoutIfNeeded()
        //self.addConstraints(heightConstraints)
        
        
        
        
        
        
        let screenSize  = UIScreen.mainScreen().bounds.size
        frame = CGRectMake(0.0, 0.0, screenSize.width, screenSize.height * proportion)
        //Removes nav bar 1 px shadow
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        //translucent = true
        //opaque = true
        
        backgroundColor =  UIColorFromRGB(0x51c1d2)
        barTintColor = UIColorFromRGB(0x51c1d2)
        tintColor = UIColorFromRGB(0xffffff)
        alpha = 0.8
       
         if let  var tv = topItem?.titleView{
            let titleLableY = tv.frame.origin.y + tv.frame.size.height/2
            let middleYPos = (self.frame.height) / 2.0
            let  ajdustHeight =  middleYPos - titleLableY
            self.setTitleVerticalPositionAdjustment(-ajdustHeight, forBarMetrics: UIBarMetrics.Default)
        }
        
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                  NSFontAttributeName: font ]
        titleTextAttributes = titleDict
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for  barView in self.subviews{
            switch barView{
                case let item as UIButton:
                    item.frame.origin.y = ((self.frame.height) / 2.0) - item.frame.size.height/2
                default: break
            }
        }
        layoutIfNeeded()
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


//  let titleYPos = self.titleVerticalPositionAdjustmentForBarMetrics(UIBarMetrics.Default)
// println(" titleYPos \(titleYPos)")
/*



*/