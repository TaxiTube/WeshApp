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

    var profile:Profile?
    private var myCustomBar: ProfileNavBar?
    private var  delegateSplitter: BLKDelegateSplitter?
    
    let screenSize  = UIScreen.mainScreen().bounds.size
     let proportion: CGFloat = 0.095
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience override init() {
        self.init()
    }
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()

    
        
        // Setup the bar
        let frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 100.0)
        
        
        
        self.myCustomBar = ProfileNavBar(frame: frame, max: CGFloat(200.0), min: CGFloat(70), handle: "Jurgen", name: "Dach Von Kloss", screenSize: screenSize)
        
        var behaviorDefiner = SquareCashStyleBehaviorDefiner()
        behaviorDefiner.addSnappingPositionProgress(0.0, forProgressRangeStart: 0.0, end: 0.5)
        behaviorDefiner.addSnappingPositionProgress( 1.0, forProgressRangeStart: 0.5, end: 1.0)
        behaviorDefiner.snappingEnabled = true
        behaviorDefiner.elasticMaximumHeightAtTop = true
       
        self.myCustomBar?.behaviorDefiner = behaviorDefiner

         
        self.delegateSplitter = BLKDelegateSplitter(firstDelegate: behaviorDefiner, secondDelegate: self)
        self.tableView.delegate =  self.delegateSplitter
    
        self.view.addSubview(self.myCustomBar!)
        // Setup the table view
        //self.tableView(registerClass:UITableViewCell.classForCoder, forCellReuseIdentifier:"cell")
        self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar!.maximumBarHeight, 0.0, 0.0, 0.0)
        
        
        var closeButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        closeButton.setImage(UIImage(named: "crossIcon"), forState: UIControlState.Normal)
        
        closeButton.frame = CGRectMake(self.myCustomBar!.frame.size.width - 40.0, 25.0, 30.0, 30.0)
        
        closeButton.tintColor = UIColor.whiteColor()
        
        closeButton.addTarget(self, action:"closeViewController:", forControlEvents:UIControlEvents.TouchUpInside)
        self.myCustomBar?.addSubview(closeButton)
        
        
        
        var menuButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        menuButton.setImage(UIImage(named: "hamburgerIcon"), forState: UIControlState.Normal)
        
        menuButton.frame = CGRectMake(15.0, 25.0, 30.0, 30.0)
        
        menuButton.tintColor = UIColor.whiteColor()
        
        menuButton.addTarget(self, action:"closeViewController:", forControlEvents:UIControlEvents.TouchUpInside)
        self.myCustomBar?.addSubview(menuButton)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {

//        self.navigationController?.navigationBarHidden = false
    }

    func closeViewController(sender: UIButton){
//        self.navigationController?.popViewControllerAnimated(true)
                            self.navigationController?.popViewControllerAnimated(true)
        NSOperationQueue.mainQueue().addOperationWithBlock(){

//            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
