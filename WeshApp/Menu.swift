//
//  Menu.swift
//  WeshApp
//
//  Created by rabzu on 25/03/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
import RNFrostedSidebar

class Menu: RNFrostedSidebar {
    
    
    
    let images = [ UIImage(named: "notifications")!,
                   UIImage(named: "nearBy")!,
                   UIImage(named: "chat")!,
                   UIImage(named: "profile")!,
                   UIImage(named: "settings")!]
    
     let colors = [UIColor.whiteColor(),
                   UIColor.whiteColor(),
                   UIColor.whiteColor(),
                   UIColor.whiteColor(),
                   UIColor.whiteColor()]

    
    override init() {
        super.init(images: images, selectedIndices: NSIndexSet(index: 1), borderColors: colors)
        setUp()
    }
    
    
    //nib initliser
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil,  bundle: nibBundleOrNil)
    }
    
    
    private func setUp(){
        self.tintColor = UIColor(red: 0x01/255, green: 0x51/255, blue: 0x5d/255, alpha: 0.5)
    }
    
}
