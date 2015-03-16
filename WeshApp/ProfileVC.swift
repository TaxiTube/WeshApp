//
//  ProfileVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 26/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var myCustomBar: FlexibleNavBar?
    var  delegateSplitter: BLKDelegateSplitter?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()

    
        
        // Setup the bar
        self.myCustomBar = FlexibleNavBar(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 100.0))
        
        var behaviorDefiner = SquareCashStyleBehaviorDefinerForTableView()
        behaviorDefiner.addSnappingPositionProgress(0.0, forProgressRangeStart: 0.0, end: 0.5)
        behaviorDefiner.addSnappingPositionProgress( 1.0, forProgressRangeStart: 0.5, end: 1.0)
        behaviorDefiner.snappingEnabled = true
        behaviorDefiner.elasticMaximumHeightAtTop = true
       
        self.myCustomBar?.behaviorDefiner = behaviorDefiner
        //self.tableView?.delegate = self.myCustomBar!.behaviorDefiner as? UITableViewDelegate
        
        self.delegateSplitter = BLKDelegateSplitter(firstDelegate: behaviorDefiner, secondDelegate: self)
        self.tableView.delegate =  self.delegateSplitter as? UITableViewDelegate
    
        self.view.addSubview(self.myCustomBar!)
        // Setup the table view
        //self.tableView(registerClass:UITableViewCell.classForCoder, forCellReuseIdentifier:"cell")
        self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar!.maximumBarHeight, 0.0, 0.0, 0.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Number of Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Number of Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 40
    }
    // MARK: - Cell for Row at IndexPath
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as?  UITableViewCell
         cell!.textLabel?.text = "jurgen"
        
        return cell!
    }
}
