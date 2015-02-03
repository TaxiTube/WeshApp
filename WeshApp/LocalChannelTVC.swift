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

class LocalChannelTVC: UITableViewController, NSFetchedResultsControllerDelegate,UIPopoverPresentationControllerDelegate {

    var fetchedResultsController : NSFetchedResultsController!
    var coreDataStack: CoreDataStack!
    var sessionMngr: SessionMngr?
    let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate

    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
       
    }
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
            var nav = UINavigationController(navigationBarClass: navbar.classForCoder, toolbarClass: nil)
            nav.pushViewController(controller.presentedViewController, animated: true)
            return nav
 
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnTap
          UIApplication.sharedApplication().statusBarHidden = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let font = UIFont(name: "Roboto-Regular", size: 5.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: font ]
        
        var backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        backButton.setTitleTextAttributes(titleDict, forState: UIControlState.Normal)
   
        self.navigationItem.backBarButtonItem = backButton
        
        
        sessionMngr = appDelegate.sessionMngr
        coreDataStack = appDelegate.coreDataStack!
        let fetchRequest = NSFetchRequest(entityName: "Channel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                      managedObjectContext: appDelegate.coreDataStack!.mainContext!,
                                                        sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        fetchedResultsController.delegate = self
        
        var error: NSError? = nil
        if (!fetchedResultsController.performFetch(&error)) {
            println("Error: \(error?.localizedDescription)") }
        
        
      
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Number of Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    // MARK: - Number of Rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    // MARK: - Cell for Row at IndexPath
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let channel = fetchedResultsController.objectAtIndexPath(indexPath) as Channel
        cell.textLabel!.text = channel.title
        return cell
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "ChannelDescriptionSegue" {
                let channelPageVC = segue.destinationViewController as ChannelPageVC
                
                let indexPath = self.tableView.indexPathForSelectedRow()
                let channel = fetchedResultsController.objectAtIndexPath(indexPath!) as Channel
                channelPageVC.channel = channel
                channelPageVC.coreDataStack = coreDataStack
                channelPageVC.sessionMngr = sessionMngr
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
