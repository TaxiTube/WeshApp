//
//  ProfileVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 26/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import CoreData
import WeshAppLibrary
import Designables
import BLKFlexibleHeightBar

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, ChannetlTableViewCellDelegate {

    //MARK:Model Proerties. CoreData
    private var channelFetechedRC: NSFetchedResultsController!
    private var coreDataStack: CoreDataStack!
    private var sessionMngr: SessionMngr?
    
    
    //MARK: Size properties
    private let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
    private let screenSize  = UIScreen.mainScreen().bounds.size
    private let proportion: CGFloat = 0.095
    
    //MARK: TableView stuffr
    var openedCell: ChannelTableViewCell?
    
    var badge: Badge?
    
    
    private var myCustomBar: FlexibleNavBar?
    private var  delegateSplitter: BLKDelegateSplitter?
    
//    let proportion: CGFloat = 0.095
    
//    var name: UILabel?
    var totem:UIImageView?
    var handle: UILabel?
    var profileName: UILabel?
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Initialisation
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience override init() {
        self.init()
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpNavbar()
        UIApplication.sharedApplication().statusBarHidden = false
        
        self.tableView.registerNib(UINib(nibName: "MyProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
       
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Set weshapp light gray seperator EFEFF4
        self.tableView.separatorColor = UIColor(red: 0xEF/255, green: 0xEF/255, blue: 0xF4/255, alpha: 1)
        
        self.sessionMngr = appDelegate.sessionMngr
        self.coreDataStack = appDelegate.coreDataStack!
        
        if badge == nil{
            self.badge = appDelegate.sessionMngr.myBadge
        }
        
        fetchFromCoreData()
        setUpData()
        setUpNavbar()

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.flashScrollIndicators()
    }
    
    override func viewDidDisappear(animated: Bool) {

//        self.navigationController?.navigationBarHidden = false
    }
    
    func fetchFromCoreData(){
        let channelFetchRequest = NSFetchRequest(entityName: "Channel")
        let channelSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        channelFetchRequest.sortDescriptors = [channelSortDescriptor]
        //        channelFetchRequest.predicate = NSPredicate(format: "Channel.author == %@", self.badge!)
        
        channelFetechedRC = NSFetchedResultsController(fetchRequest: channelFetchRequest,
            managedObjectContext: appDelegate.coreDataStack!.mainContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        
        channelFetechedRC.delegate = self
        //Fetching with NSFetchedResultsController returns a Boolean to denote success or failure.
        var error: NSError? = nil
        if (!channelFetechedRC.performFetch(&error))  {
            println("Error: \(error?.localizedDescription)")
        }
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
        return channelFetechedRC.sections!.count
    }
    //Is called before cellForRowAtIndexPath
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return screenSize.width / 4.11
    }
    
    // MARK: - Number of Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = channelFetechedRC.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    // MARK: - TableView Stuff
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        var cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as? ChannelTableViewCell
        let channel = channelFetechedRC.objectAtIndexPath(indexPath) as Channel
        cell!.title.text = channel.title
        //TODO if name is known show real name instead
        cell!.subTitle.text = timeAgoSinceDate(channel.date, true)
        
        //TODO: cell!.image     =
        //Todo Count number of posts the channe has cell!.counter =
        cell!.delegate = self
        cell!.counter.text = String(channel.posts.count)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("profileToChannel", sender: self)
    }
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as ChannelTableViewCell?
        cell?.highlightCell(false)
        
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as ChannelTableViewCell?
        cell?.highlightCell(true)
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "profileToChannel" {
            //                self.navigationController!.navigationBarHidden = true
            let channelVC = segue.destinationViewController as ChannelTVC
            //                channelVC.transitioningDelegate = self.transitionManager
            //                var channelVC = navController.topViewController as ChannelTVC
            let indexPath = self.tableView.indexPathForSelectedRow()
            // If as Channel else as Profile
            
            let channel = channelFetechedRC.objectAtIndexPath(indexPath!) as Channel
            channelVC.channel = channel
            channelVC.coreDataStack = coreDataStack
            channelVC.sessionMngr = sessionMngr
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
            
        } else if segue.identifier == "nearbyToProfile"{
            
            var profileVC = segue.destinationViewController as ProfileVC
            //                var profileVC = navController.topViewController as ProfileVC
            
            //                profileVC.transitioningDelegate = self.transitionManager
        }
    }
    
    
    
    //MARK: ChannetlTableViewCellDelegate
    func pauseAction(){
        println("Pause Action pressed")
    }
    
    func cellDidOpen(cell: ChannelTableViewCell) {
        
        if cell != openedCell{
            if let oc = openedCell?{
                
                openedCell!.closeCell()
            }
            openedCell = cell
        }
        
        //stop scrolling
        var currentEditingIndexPath = tableView.indexPathForCell(cell)
        //self.cellsCurrentlyEditing?.addObject(currentEditingIndexPath!)
    }
    
    func cellDidClose(cell: ChannelTableViewCell) {
        if cell == openedCell{
            openedCell = nil
        }
        //continue scrolling
        var currentEditingIndexPath = tableView.indexPathForCell(cell)
        // self.cellsCurrentlyEditing?.removeObject(currentEditingIndexPath!)
        //tableView.scrollEnabled = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let oc = openedCell?{
            oc.closeCell()
        }
    }
    
    func setUpData(){
        self.handle = UILabel()
        self.handle?.text = "#\(self.badge!.handle)"
        self.handle?.sizeToFit()

        //self.totem =  UIImageView(image: UIImage(named: self.badge?.totem!))
        self.totem =  UIImageView(image: UIImage(named:"Lion"))
        //        if let n = self.badge?.profile. {
        //            self.name?.text = n
        //        }
        
    }
    
    private func setUpNavbar(){
        self.setNeedsStatusBarAppearanceUpdate()
        
        //name init
        
        //totem init
        var profileImageView = UIImageView(image: UIImage(named: "Lion"))

        //handle init
        
        
        
        // Setup the bar
        let frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 100.0)
//        self.handle = UILabel()
//        self.handle?.text  = "#Jurgen"
        self.profileName = UILabel()
        self.profileName?.text = "Dach Von Kloss"
        
        self.myCustomBar = FlexibleNavBar(frame: frame, handle: self.handle!,  name: self.profileName, totem: profileImageView, rightItem: .Cross )
        
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
     }
    
    
}
