//
//  NearbyVC.swift
//  WeshApp
//
//  Created by rabzu on 20/03/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
import CoreData
import Designables
import RNFrostedSidebar
import BLKFlexibleHeightBar

class NearbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource,  NSFetchedResultsControllerDelegate,UIPopoverPresentationControllerDelegate, ChannetlTableViewCellDelegate,RNFrostedSidebarDelegate {
    
    
    
    
    //MARK: NavBar properties
    private var myCustomBar: FlexibleNavBar?
    private var delegateSplitter: BLKDelegateSplitter?
    private let navbarProportion: CGFloat = 4.87
    var segControl: WeshappSegControl!
    
    
    
    private let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
    private let screenSize  = UIScreen.mainScreen().bounds.size
    private let proportion: CGFloat = 0.095

    //MARK:Model Proerties. CoreData
    private var badgeFetchedRC: NSFetchedResultsController!
    private var channelFetechedRC: NSFetchedResultsController!
    private var currentFetchedRC : NSFetchedResultsController!
    private var coreDataStack: CoreDataStack!
    private var sessionMngr: SessionMngr?
    
   //MARK: Menu
    private var callout: RNFrostedSidebar?
    //MARK:Transition management
    let transitionManager = TransitionManager()

    //MARK: TableView stuff
    var openedCell: ChannelTableViewCell?
    @IBOutlet weak var tableView: UITableView!
    
    
//    @IBAction func showMenu(sender: UIBarButtonItem) {
//           callout!.show()
//    }
//    
    private func setUpMenu(){
        
        let images = [ UIImage(named: "Notifications")!,
                       UIImage(named: "NearBy")!,
                       UIImage(named: "Chat")!,
                       UIImage(named: "Profile")!,
                       UIImage(named: "Settings")!]
        
       let colors = [UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor()]
       callout = RNFrostedSidebar(images: images , selectedIndices:  NSIndexSet(index: 1), borderColors: colors)
       callout?.tintColor = UIColor(red: 0x01/255, green: 0x51/255, blue: 0x5d/255, alpha: 0.5)
       callout!.delegate = self
     
    }
    
     func sidebar(sidebar: RNFrostedSidebar!, didTapItemAtIndex index: UInt) {
        switch index{
            //notification centre
            case 0:
                sidebar.dismissAnimated(true)
            //nearby
            case 1:
                sidebar.dismissAnimated(true)
            //chat
            case 2:
                sidebar.dismissAnimated(true)
            //profile
            case 3:
                sidebar.dismissAnimated(true)
                
//                dispatch_async(dispatch_get_main_queue()){
//                    self.performSegueWithIdentifier("nearbyToProfile", sender: self)
//                }
                
                var profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("profileVC") as UIViewController
//                self.performSegueWithIdentifier("nearbyToProfile", sender: self)

                self.navigationController?.showViewController(profileVC, sender: self)
            //settings
            case 4:
                sidebar.dismissAnimated(true)
            default: break
        }
    }


    
//    MARK: Segmentation Control
    func segmentChanged(sender: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            currentFetchedRC = channelFetechedRC
            var error: NSError? = nil
            if (!currentFetchedRC.performFetch(&error))  {
                println("Error: \(error?.localizedDescription)")
            }
            
            //animation
            UIView.transitionWithView(self.tableView, duration: 0.35,
                                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                                   animations: { self.tableView.reloadData() },
                                                   completion: { (v:Bool) in ()})
          
        case 1:
            currentFetchedRC = badgeFetchedRC
            var error: NSError? = nil
            if (!currentFetchedRC.performFetch(&error))  {
                println("Error: \(error?.localizedDescription)") }
            //animation
            UIView.transitionWithView(self.tableView, duration: 0.35,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: {
                    self.tableView.reloadData()
                },
                completion: { (v:Bool) in ()})
       
        default:
            break
        }
    
    
    }

 
    //MARK: Set up
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarHidden = false
        
        setUpNavBar()
        setUpMenu()

        self.tableView.registerNib(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: "channelCell")
        self.tableView.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //Set weshapp light gray seperator
        self.tableView.separatorColor = UIColor(red: 0xf7/255, green: 0xf7/255, blue: 0xf7/255, alpha: 1)
        
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = true

        sessionMngr = appDelegate.sessionMngr
        coreDataStack = appDelegate.coreDataStack!
      
        let channelFetchRequest = NSFetchRequest(entityName: "Channel")
        let channelSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        channelFetchRequest.sortDescriptors = [channelSortDescriptor]
        channelFetechedRC = NSFetchedResultsController(fetchRequest: channelFetchRequest,
                                                      managedObjectContext: appDelegate.coreDataStack!.mainContext!,
                                                        sectionNameKeyPath: nil,
                                                                 cacheName: nil)
       //TODO: Filter my badge out
        let badgeFetchRequest = NSFetchRequest(entityName: "Badge")
        let badgeSortDescriptor = NSSortDescriptor(key: "handle", ascending: true)

        badgeFetchRequest.sortDescriptors = [badgeSortDescriptor]
        badgeFetchedRC = NSFetchedResultsController(fetchRequest: badgeFetchRequest,
                                            managedObjectContext: appDelegate.coreDataStack!.mainContext!,
                                              sectionNameKeyPath: nil,
                                                       cacheName: nil)
        
        
        currentFetchedRC  = channelFetechedRC
        currentFetchedRC.delegate = self
        
        var error: NSError? = nil
        if (!currentFetchedRC.performFetch(&error))  {
            println("Error: \(error?.localizedDescription)")
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: set up navbar using BLKFlexibleHeightBar
    
    private func setUpNavBar(){
        self.setNeedsStatusBarAppearanceUpdate()
        let segControlWidthProp: CGFloat = 0.54
        let segControlHeightToWidth:CGFloat = 12.76
        
        // Setup the bar
        let maxHeight = screenSize.width / navbarProportion
        //Setup the segmentation contorl
        let segControlframe = CGRectMake(20, 20, screenSize.width * segControlWidthProp,
                                                 screenSize.width / segControlHeightToWidth)
        
        self.segControl = WeshappSegControl(frame: segControlframe, items: ["Species", "Habitat"] )
        self.segControl.addTarget(self, action: "segmentChanged:", forControlEvents: .ValueChanged)
        self.segControl.setWidth(screenSize.width * segControlWidthProp / 2, forSegmentAtIndex: 0)
        self.segControl.setWidth(screenSize.width * segControlWidthProp / 2, forSegmentAtIndex: 1)
        
        let frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 20.0)
        self.myCustomBar = FlexibleNavBar(frame: frame, max: maxHeight , min: CGFloat(20),  centreItem: segControl)
        
        var behaviorDefiner = FacebookStyleBarBehaviorDefiner()
        behaviorDefiner.addSnappingPositionProgress( 0.0, forProgressRangeStart: 0.0, end: 0.5)
        behaviorDefiner.addSnappingPositionProgress( 1.0, forProgressRangeStart: 0.5, end: 1.0)
        behaviorDefiner.snappingEnabled = true
        
        self.myCustomBar?.behaviorDefiner = behaviorDefiner

        //Assigns tow delegates
        self.delegateSplitter = BLKDelegateSplitter(firstDelegate: behaviorDefiner, secondDelegate: self)
        self.tableView.delegate =  self.delegateSplitter
        
        self.view.addSubview(self.myCustomBar!)
        self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar!.maximumBarHeight - 20, 0.0, 0.0, 0.0)
    }
    

    // MARK: - Number of Sections
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentFetchedRC.sections!.count
    }
    
    // MARK: - Number of Rows
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = currentFetchedRC.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    // MARK: - Cell for Row at IndexPath
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ChannelTableViewCell?
        switch segControl.selectedSegmentIndex
        {
            case 0:
                 cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath) as? ChannelTableViewCell
                let channel = currentFetchedRC.objectAtIndexPath(indexPath) as Channel
                cell!.title.text = channel.title
                //TODO if name is known show real name instead
                cell!.subTitle.text = channel.author.handle
            
                //TODO: cell!.image     =
                //Todo Count number of posts the channe has cell!.counter =
                
            case 1:
                 cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as? ChannelTableViewCell
                let badge = currentFetchedRC.objectAtIndexPath(indexPath) as Badge
                cell!.title.text  = badge.handle
                //TODO if name is known show real name instead
                //TODO: cell!.image =
                //Todo Count number of channels the authork has cell!.counter =


            default:
                break;
        }
        
 
        let view1 = UIView()
        let v = UIView()
        v.backgroundColor = UIColor.grayColor()
        cell?.selectedBackgroundView = v
        cell!.layoutSubviews()
        cell!.delegate = self
        cell!.contentView
        /*
        if cellsCurrentlyEditing!.containsObject(indexPath){
            cell!.openCell()
        }
        */
        return cell!
    }
    
    func darkerColor( color: UIColor) -> UIColor {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        let hueObtained = color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        if hueObtained {
            return UIColor(hue: h, saturation: s, brightness: b * 0.75, alpha: a)
        }
        return color
    }
    
    //Is called before cellForRowAtIndexPath
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return screenSize.width / 4.11
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("toChannelVC", sender: self)
//        dispatch_async(dispatch_get_main_queue()){
//            self.performSegueWithIdentifier("toChannelTVC", sender: self)
//        }
        
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
    
    
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            if segue.identifier == "toChannelVC" {
//                self.navigationController!.navigationBarHidden = true
                let channelVC = segue.destinationViewController as ChannelTVC
                channelVC.transitioningDelegate = self.transitionManager
//                var channelVC = navController.topViewController as ChannelTVC
                let indexPath = self.tableView.indexPathForSelectedRow()
                // If as Channel else as Profile
                
                let channel = currentFetchedRC.objectAtIndexPath(indexPath!) as Channel
                channelVC.channel = channel
                channelVC.coreDataStack = coreDataStack
                channelVC.sessionMngr = sessionMngr
                tableView.deselectRowAtIndexPath(indexPath!, animated: true)
                

        } else if segue.identifier == "nearbyToProfile"{
                
                var profileVC = segue.destinationViewController as ProfileVC
//                var profileVC = navController.topViewController as ProfileVC

                profileVC.transitioningDelegate = self.transitionManager

        }
        
    }
    
    //MARK: NSFetchedResultsController Delegate methods
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        tableView.beginUpdates()
    }
    
    func controller (controller: NSFetchedResultsController,
       didChangeObject anObject: AnyObject,
          atIndexPath indexPath: NSIndexPath!,
             forChangeType type: NSFetchedResultsChangeType,
                   newIndexPath: NSIndexPath!) {
    
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Update:
                let cell = tableView.cellForRowAtIndexPath(indexPath) //as TeamCell
                //configureCell(cell, indexPath: indexPath)
            case .Move: tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            default: break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.endUpdates()
    }

  
    
    // Override to support conditional editing of the table view.
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
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
    

    
    //MARK: Popover controller
    @IBAction func handlePopover(sender: UIBarButtonItem) {
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("createChannelPopover") as UIViewController
        popoverVC.modalPresentationStyle = .Popover
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.barButtonItem = sender
            //popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .Any
            
            popoverController.delegate = self
        }
        //self.navigationController!.pushViewController(popoverVC, animated: true)
        presentViewController(popoverVC, animated: true, completion: nil)
        
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .OverFullScreen
    }
    
    
    func presentationController(              controller: UIPresentationController!,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController! {
            
            var navbar = navigationController!.navigationBar
            var titleLabel = UILabel()
            let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
            let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: font ]
            titleLabel.attributedText = NSAttributedString(string: "Create Habitat",
                attributes: titleDict)
            titleLabel.sizeToFit()
            
            var nav = UINavigationController(navigationBarClass: navbar.classForCoder, toolbarClass: nil)
            let midY = (nav.navigationBar.frame.height - 20) / 2.0
            
            let screenSize  = UIScreen.mainScreen().bounds.size.width
            
            let midX = (screenSize/2) - (titleLabel.frame.width / 2)
            
            titleLabel.frame.origin = CGPoint(x: midX, y: midY)
            
            nav.navigationBar.addSubview(titleLabel)
            nav.pushViewController(controller.presentedViewController, animated: true)
            return nav
            
    }
    
   

}
