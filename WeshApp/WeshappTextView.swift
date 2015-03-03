//
//  BorderTextView.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

public protocol WeshappUITextViewDelegate: UITextViewDelegate{
    func textViewDidChangeHeight(textView: WeshappTextView)
}


@IBDesignable
public class WeshappTextView: UITextView{
    
    @IBInspectable var top: CGFloat = 0
    @IBInspectable var left: CGFloat = 0
    @IBInspectable var bottom: CGFloat = 0
    @IBInspectable var right: CGFloat = 0
    @IBInspectable var placeholder: String = ""
    @IBInspectable var realTextColor: UIColor = UIColor.blackColor()
    
    @IBInspectable var placeholderColor: UIColor  = UIColor(white:0.80, alpha:1)
    
    public var weshappDelegate: WeshappUITextViewDelegate?
    
    var initialSize: CGSize!

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
     public override func layoutSubviews() {

//        if heightDidChange() {
//            println("text changed")
//            weshappDelegate!.textViewDidChangeHeight(self)
//        }
        
    }
    
    public override func didChange(changeKind: NSKeyValueChange, valuesAtIndexes indexes: NSIndexSet, forKey key: String) {
        
      
    }
    
    
    func setUp(){
        
        initialSize = frame.size
        println(initialSize)
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
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("editingChanged:"),
            name: UITextViewTextDidChangeNotification,
            object: nil)
        
    }
    

    func beginEditing(notification: NSNotification){
        if placeholder == self.text {
            self.text = ""
            self.textColor = realTextColor
        }
    }
    func editingChanged(notification: NSNotification){
        println("text changed  \(initialSize.height)")
        if heightDidChange() {
//           weshappDelegate!.textViewDidChangeHeight(self)
        }
    }
    
    func end(notification: NSNotification){
        if self.text == "" {
            self.text = placeholder
            self.textColor = placeholderColor
        }
    }
    func heightDidChange()->Bool{
        println("\(initialSize.height != self.frame.height)")
        if initialSize.height != self.frame.height{
            initialSize = self.frame.size
            return true
        } else {
            return false
        }
        
    }
    
}
