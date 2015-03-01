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
    
    @IBInspectable var top: CGFloat = 0
    @IBInspectable var left: CGFloat = 0
    @IBInspectable var bottom: CGFloat = 0
    @IBInspectable var right: CGFloat = 0
    @IBInspectable var placeholder: String = ""
    @IBInspectable var realTextColor: UIColor = UIColor.blackColor()
    
    @IBInspectable var placeholderColor: UIColor  = UIColor(white:0.80, alpha:1)

    public override func awakeFromNib() {
        setUp()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override func drawRect(rect: CGRect){
//
//        let grey80 = UIColor(white:0.80, alpha:1)
//        //self.layer.borderWidth = 0.5
//        //self.layer.borderColor = grey80.CGColor
//        //self.layer.cornerRadius = 8
//

////    textContainerInset = UIEdgeInsetsMake(8, 6, 8, 6);
    textContainerInset = UIEdgeInsetsMake(top, left, bottom, right)

    }
    
    func setUp(){
        
        self.text = placeholder
        self.textColor = placeholderColor
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("beginEditing:"),
            name: UITextViewTextDidBeginEditingNotification,
            object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("end:"),
            name: UITextViewTextDidEndEditingNotification,
            object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(     self,
//            selector: Selector("editingChanged:"),
//            name: UITextViewTextDidChangeNotification,
//            object: nil)
        
    }
    

    func beginEditing(notification: NSNotification){
        if placeholder == self.text {
            self.text = ""
            self.textColor = realTextColor
        }
    }
//    func editingChanged(notification: NSNotification){
//        if self.text == "" && self.textColor == realTextColor{
//            self.text = placeholder
//            self.textColor = placeholderColor
//            self.selectedRange = NSMakeRange(0, 0)
//        }
//    }
    
    func end(notification: NSNotification){
        if self.text == "" {
            self.text = placeholder
            self.textColor = placeholderColor
        }
    }
    
}
