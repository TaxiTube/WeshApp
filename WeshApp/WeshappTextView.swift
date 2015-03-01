//
//  BorderTextView.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

@IBDesignable
public class WeshappTextView: UITextView{
    
    let top: CGFloat = 0
    let left: CGFloat = 0
    let bottom: CGFloat = 0
    let right: CGFloat = 0
    
    
    /*
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    */
   public override func drawRect(rect: CGRect){
        
        let grey80 = UIColor(white:0.80, alpha:1)
        //self.layer.borderWidth = 0.5
        //self.layer.borderColor = grey80.CGColor
        //self.layer.cornerRadius = 8
        //self.font = UIFont(name: "Roboto-light", size: 14.0)!
        font = UIFont(name: "TitilliumText25L-250wt", size: 15.0)!

        textColor = grey80
        textContainerInset = UIEdgeInsetsMake(top, left, bottom, right)
//    textContainerInset = UIEdgeInsetsMake(8, 6, 8, 6);


    }
    
}
