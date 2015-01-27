//
//  TestViewController.swift
//  WeshApp
//
//  Created by Zuka on 1/23/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

class TestViewController: UINavigationController {

    override func viewDidAppear(animated: Bool)  {
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        nav?.frame = CGRectMake(0.0, 0.0, 320, 180);
        println(nav)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
