//
//  WeshappViewController.swift
//  WeshApp
//
//  Created by rabzu on 25/03/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import RNFrostedSidebar
import BLKFlexibleHeightBar

class WeshappViewController: UIViewController, RNFrostedSidebarDelegate {
    
    
    
    private let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
    var callout: Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callout = appDelegate.menu
        callout!.delegate = self
 }
   
    //MARK: menu
    func showMenu() {
        callout!.show()
    }
    
    func sidebar(sidebar: RNFrostedSidebar!, didTapItemAtIndex index: UInt) {
        switch index{
            //notification centre
        case 0:
            sidebar.dismissAnimated(true)
            println("12")
            //nearby
        case 1:
            sidebar.dismissAnimated(true)
            //chat
        case 2:
            sidebar.dismissAnimated(true)
            //profile
        case 3:
            sidebar.dismissAnimated(true)
            self.performSegueWithIdentifier("nearbyToProfile", sender: self)
        case 4:
            sidebar.dismissAnimated(true)
        default: break
        }
    }
    
    

}
