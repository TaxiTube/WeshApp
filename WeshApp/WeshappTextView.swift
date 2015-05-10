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
    
    //A boolean that tracks wheather the placeholder is showing or not
    private var showPlaceholder = true
    public weak var weshappDelegate: WeshappUITextViewDelegate?
    
    var initialNumRows: Int!

    public override func awakeFromNib() {
        setUp()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override func drawRect(rect: CGRect){
        textContainerInset = UIEdgeInsetsMake(top, left, bottom, right)
    }

    
    func setUp(){

        self.textColor = placeholderColor
        text = placeholder
        
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
        
//        println("setting up with content size \(self.contentSize.height)")
          initialNumRows = numberOfLines()
    }
    

    func beginEditing(notification: NSNotification){
        self.showPlaceholder = false
        if placeholder == self.text {
            self.text = ""
            self.textColor = realTextColor
        }
    }
    func editingChanged(notification: NSNotification){
//        println("text changed  \(initialContentSize.height)")
        if heightDidChange() {
           weshappDelegate!.textViewDidChangeHeight(self)
        }
    }
    
    func end(notification: NSNotification){
        if self.text == "" {
            self.text = placeholder
            self.showPlaceholder = true
            self.textColor = placeholderColor
        }
    }
    func heightDidChange()->Bool{
        if initialNumRows != numberOfLines(){
            initialNumRows = numberOfLines()
            return true
        } else {
            return false
        }
        
    }
    //get mempty text if placeholder is visible
    public func getText() -> String{
        if self.showPlaceholder  == true {
            return ""
        }
        return self.text
    }

    public func numberOfLines() -> Int{
        
        var max = CGFloat.max
        var sizeThatFitsTextView = sizeThatFits(CGSizeMake(frame.size.width, max ))
        var rows = round( (sizeThatFitsTextView.height - textContainerInset.top - textContainerInset.bottom) / font.lineHeight )
        
        return Int(rows)
    }
}
