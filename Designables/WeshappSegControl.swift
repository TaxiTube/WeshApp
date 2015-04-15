//
//  WeshappSegControl.swift
//  WeshApp
//
//  Created by rabzu on 29/01/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

 public class WeshappSegControl: UISegmentedControl, UIGestureRecognizerDelegate {
    
    let font = UIFont(name: "TitilliumText25L-250wt", size: 15.0)!
    var isRight = false

     let selectedColour = UIColor(red: 0xff/255, green: 0x59/255, blue: 0x59/255, alpha: 1.0)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    required  public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
        
    }

    required override public init(items: [AnyObject]) {
        super.init(items: items)
 
    }
    
    public convenience init(frame: CGRect, items: [String]){
    
        self.init(frame: frame)
        let recognizer = UITapGestureRecognizer (target: self, action:Selector("handleTap:"))
        recognizer.delegate = self
        
        for i in 0...items.count - 1{
            self.insertSegmentWithTitle(items[i], atIndex: i, animated: false)
        }
        self.selectedSegmentIndex = 0
        setUp()
    }
    
    
     func setUp(){
        
        var segLeft = subviews[0] as! UIView
        var segRight = subviews[1] as! UIView
        
        segLeft.tintColor = selectedColour
        segRight.tintColor =  UIColor.whiteColor()
        
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                  NSFontAttributeName: font ]
        
        setTitleTextAttributes(titleDict, forState: UIControlState.Selected)
        

        setTitleTextAttributes([NSFontAttributeName: font ], forState: UIControlState.Normal)
       
//        segLeft.tintColor = UIColor(red: 0xff/255, green: 0x59/255, blue: 0x59/255, alpha: 1.0)
    
        
       

    }
    
    
    
    override public func didChangeValueForKey(key: String) {
        let subviews = self.subviews
        var segLeft = subviews[1] as! UIView
        var segRight = subviews[0] as! UIView
        
       
        switch self.selectedSegmentIndex{
            case 0:
                segLeft.tintColor = selectedColour
                segRight.tintColor =  UIColor.whiteColor()
            case 1:
                segRight.tintColor = selectedColour
                segLeft.tintColor =  UIColor.whiteColor()
            default: break
        }
    }
    
    
    public  func handleTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state  == UIGestureRecognizerState.Began{
            self.selectedSegmentIndex = 0

            isRight = true
        }else if recognizer.state  == UIGestureRecognizerState.Ended{
            self.selectedSegmentIndex = 1

            isRight = false
        }
        setNeedsDisplay()
    }

    
}
