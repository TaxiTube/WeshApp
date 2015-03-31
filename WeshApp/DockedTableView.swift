//
//  DockedTableView.swift
//  WeshApp
//
//  Created by rabzu on 31/03/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

class DockedTableView: UITableView {

    var accessoryDock: UIView?
    
    //Return your custom input accessory view
    override var inputAccessoryView: UIView! {
        return accessoryDock
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    

    
    
//    //Used to setup and change default constraints height
//    func setUpInputAccessoryView(){
//        
//        //Set Weshapp Delagete
////        self.weshappDelegate = self
//        
//        //Not sure when to use this: tableView.inputAccessoryView!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
//        var constraints:[NSLayoutConstraint] = self.inputAccessoryView!.constraints() as Array
//        //find default constraint
//        for (c: NSLayoutConstraint) in constraints{
//            
//            if c.firstAttribute == NSLayoutAttribute.Height{
//                c.constant = screenSize.width / 7.5
//                break
//            }
//        }
//        //Add text view height constrain
//        textViewHeightConstraint = NSLayoutConstraint(item: self.textView,
//            attribute: NSLayoutAttribute.Height,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute,
//            multiplier: 1,
//            constant: (screenSize.width / 7.5))
//        
//        self.tableView.inputAccessoryView!.addConstraint(self.textViewHeightConstraint!)
//        self.tableView.updateConstraints()
//        
//        inputAccessoryViewIsSetUp = true
//    }
    
    
}
