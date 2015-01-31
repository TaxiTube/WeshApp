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
       
        super.layoutSubviews()
       // self.font = adjustFont()


    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  
    override public func layoutSubviews() {
        println(" frame1: \(self.frame.size.height) " )

        super.layoutSubviews()
        println(" frame2: \(self.frame.size.height) " )

        //self.preferredMaxLayoutWidth = self.frame.size.width
        //self.font = adjustFont()
        super.layoutSubviews()

    }

    func adjustFont() -> UIFont{
        let MAX = 35
        let MIN = 3
      

         for var i = MAX; i > MIN; --i {
    
            var font = UIFont(name: "TitilliumText25L-250wt", size: CGFloat(i))!
            

            var attributedText = NSAttributedString(string: text!, attributes: [NSFontAttributeName: font])
        
            var rectSize = attributedText.boundingRectWithSize(CGSizeMake(self.frame.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil)
            let screenSize  = UIScreen.mainScreen().bounds.size

           // println("fontrect: \(rectSize.size.height) - frame: \(self.frame.size.height) " )
            
            if (rectSize.size.height <= self.frame.size.height) {
                return UIFont(name: self.font.fontName, size: CGFloat(i))!
            }
        }
        return UIFont(name: "TitilliumText25L-250wt", size: CGFloat(MIN))!
    }
    
}
