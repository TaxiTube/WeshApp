//
//  ProfileVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 26/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: font ]
        
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        backButton.setTitleTextAttributes(titleDict, forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
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
