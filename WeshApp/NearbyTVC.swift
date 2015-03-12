//
//  LocalChannelTVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import CoreData
import Designables

class NearbyTVC: UITableViewController, NSFetchedResultsControllerDelegate,UIPopoverPresentationControllerDelegate, ChannetlTableViewCellDelegate {

    var badgeFetchedRC: NSFetchedResultsController!
    var channelFetechedRC: NSFetchedResultsController!
    var currentFetchedRC : NSFetchedResultsController!
    var coreDataStack: CoreDataStack!
    var sessionMngr: SessionMngr?
    let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
    let screenSize  = UIScreen.mainScreen().bounds.size
  //  var cellsCurrentlyEditing: NSMutableSet?
    var openedCell: ChannelTableViewCell?

//    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    //MARK: Segmentation Control
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        switch segControl.selectedSegmentIndex
        {
        case 0:
           currentFetchedRC = channelFetechedRC
           var error: NSError? = nil
           if (!currentFetchedRC.performFetch(&error))  {
            println("Error: \(error?.localizedDescription)") }
           //animation
           UIView.transitionWithView(self.tableView, duration: 0.35,
                                                      options: UIViewAnimationOptions.TransitionFlipFromLeft,
                                                   animations: { self.tableView.reloadData() },
                                                   completion: { (v:Bool) in ()})
          
        case 1:
            currentFetchedRC = badgeFetchedRC
            var error: NSError? = nil
            if (!currentFetchedRC.performFetch(&error))  {
                println("Error: \(error?.localizedDescription)") }
            //animation
            UIView.transitionWithView(self.tableView, duration: 0.35,
                options: UIViewAnimationOptions.TransitionFlipFromRight,
                animations: {
                    self.tableView.reloadData()
                },
                completion: { (v:Bool) in ()})
       
        default:
            break;
        }
    
    
    }



    //MARK: Set up
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shyNavBarManager.scrollView = self.tableView

        tableView.estimatedRowHeight = 44
        
        UIApplication.sharedApplication().statusBarHidden = false
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = true

        let font = UIFont(name: "TitilliumText25L-250wt", size: 5.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: font ]
        
//        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
//        backButton.setTitleTextAttributes(titleDict, forState: UIControlState.Normal)
   
//        self.navigationItem.backBarButtonItem = backButton
//        
        
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
        
       // cellsCurrentlyEditing = NSMutableSet()
    }
    
    override func viewDidAppear(animated: Bool) {
//        self.navigationController!.navigationBarHidden = false

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Number of Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentFetchedRC.sections!.count
    }
    
    // MARK: - Number of Rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = currentFetchedRC.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    // MARK: - Cell for Row at IndexPath
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return screenSize.width / 4.11
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("toChannelTVC", sender: self)
        }
    }
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "toChannelTVC" {
//                self.navigationController!.navigationBarHidden = true
                let navController = segue.destinationViewController as UINavigationController
                var channelVC = navController.topViewController as ChannelTVC
                let indexPath = self.tableView.indexPathForSelectedRow()
                // If as Channel else as Profile
                let channel = currentFetchedRC.objectAtIndexPath(indexPath!) as Channel
                channelVC.channel = channel
                channelVC.coreDataStack = coreDataStack
                channelVC.sessionMngr = sessionMngr
                tableView.deselectRowAtIndexPath(indexPath!, animated: true)
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
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
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
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
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
