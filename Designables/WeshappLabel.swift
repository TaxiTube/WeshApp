//
//  WeshappLabel.swift
//  WeshApp
//
//  Created by rabzu on 30/01/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit


public class WeshappLabel: UILabel {

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        //adjustsFontSizeToFitWidth = true
    }
   
  
    override public func layoutSubviews() {
       
        //minimumScaleFactor = 0.5

        //println(" after layout: \(self.frame.size) " )
        
        //super.layoutSubviews()
        //font = adjustFont()
        
        //let rect = self.textRectForBounds(self.bounds, limitedToNumberOfLines: 1)
       // println("me \(rect.size) font \(self.font.pointSize)")
        //var attributedText = NSAttributedString(string: text!, attributes: [NSFontAttributeName: font])
        
//        var rectSize = attributedText.boundingRectWithSize(
//            CGSizeMake(self.frame.size.width, CGFloat.max),
//            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
//            context:nil)
      //  println("diff: \(rect.size.height - rectSize.size.height)")


        //adjustsFontSizeToFitWidth = true
//        sizeToFit()
        super.layoutSubviews()

        
    }
    
    
//    var topInset:       CGFloat = 10
//    var rightInset:     CGFloat = 10
//    var bottomInset:    CGFloat = 10
//    var leftInset:      CGFloat = 10
//    
//    override public func drawTextInRect(rect: CGRect) {
//        var insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
//        self.setNeedsLayout()
//        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
//    }
//    
    
    
    
//    override public class func requiresConstraintBasedLayout() -> Bool {
//        return true
//    }
//    
//    override public func intrinsicContentSize() -> CGSize {
//        let screenSize  = UIScreen.mainScreen().bounds.size
//
//        return CGSizeMake(screenSize.width, screenSize.height * 0.03)
//    }
//    func adjustFont() -> UIFont{
//        let MAX = 35.0
//        let MIN = 3.0
//      
//
//         for var i = MAX; i > MIN;  i = i - 0.1 {
//    
//            var font = UIFont(name: "TitilliumText25L-250wt", size: CGFloat(i))!
//          //  println(i)
//
//            var attributedText = NSAttributedString(string: text!,
//                                                attributes: [NSFontAttributeName: font])
//        
//            var rectSize = attributedText.boundingRectWithSize(
//                CGSizeMake(self.frame.size.width, CGFloat.max),
//                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
//                context:nil)
//
//          //    println("fontrect: \(rectSize.size.height) - frame: \(self.bounds.size.height) " )
//            
//            if (rectSize.size.height <= self.bounds.height + 10) {
//                return UIFont(name: self.font.fontName, size: CGFloat(i))!
//            }
//        }
//        return UIFont(name: "TitilliumText25L-250wt", size: CGFloat(MIN))!
//    }
  
}
