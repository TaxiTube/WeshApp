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
    
}
