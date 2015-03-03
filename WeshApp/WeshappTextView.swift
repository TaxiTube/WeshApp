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
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0
    @IBInspectable var placeholder: String = ""
    @IBInspectable var realTextColor: UIColor = UIColor.blackColor()
    @IBInspectable var top: Bool = false
    @IBInspectable var bottom: Bool = false
    @IBInspectable var left: Bool = false
    @IBInspectable var right: Bool = false
    @IBInspectable var lineColor: UIColor = UIColor.grayColor()
    @IBInspectable var lineWidth: CGFloat = 0.0
    @IBInspectable var placeholderColor: UIColor  = UIColor(white:0.80, alpha:1)
    
    public var weshappDelegate: WeshappUITextViewDelegate?
    
    var initialContentSize: CGSize!

    public override func awakeFromNib() {
        println("awakefrom nib")
        setUp()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("init decoder")

    }
  
    
    //    UIColorFromRGB(0xf7f7f7)
    
    
    let grey80 = UIColor(white:0.80, alpha:1)
    
    
    
    override public func drawRect(rect:CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        if top {
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
        }
        
        if bottom{
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        }
        
        if left{
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        }
        
        if right{
            CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        }
        
        
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, lineWidth);
        CGContextStrokePath(context);
        textContainerInset = UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
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
        
        println("setting up with content size \(self.contentSize.height)")
        initialContentSize = self.contentSize
    }
    

    func beginEditing(notification: NSNotification){
        if placeholder == self.text {
            self.text = ""
            self.textColor = realTextColor
        }
    }
    func editingChanged(notification: NSNotification){
        println("text changed  \(initialContentSize.height)")
        if heightDidChange() {
           weshappDelegate!.textViewDidChangeHeight(self)
        }
    }
    
    func end(notification: NSNotification){
        if self.text == "" {
            self.text = placeholder
            self.textColor = placeholderColor
        }
    }
    func heightDidChange()->Bool{
        
        println("initialContentSize.height = \(initialContentSize.height) self.frame.height = \(self.contentSize.height)    \(initialContentSize.height != self.contentSize.height)")
        
        if initialContentSize.height != self.contentSize.height{
            initialContentSize = self.contentSize
            return true
        } else {
            return false
        }
        
    }
    
}
