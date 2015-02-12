//
//  ChannelWallTVC.swift
//  WeshApp
//
//  Created by rabzu on 21/12/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import CoreData


class ChannelWallTVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var channel: Channel?
    var fetchedResultsController : NSFetchedResultsController!
    var coreDataStack: CoreDataStack!
    let screenSize  = UIScreen.mainScreen().bounds.size


    @IBOutlet weak var channelBanner: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var channelDesc: UITextView!
    @IBOutlet weak var channelTitle: UILabel!
    
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
      
        channelTitle.text = channel!.title
        channelDesc.text = channel!.desc
        //channelBanner.image = UIImage(data: channel!.photo.photo)
        //profileImage.image = UIImage(data: channel!.author.photo.photo)
        
        let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
        coreDataStack = appDelegate.coreDataStack!
        let managedObjectContext = appDelegate.coreDataStack!.mainContext!
        let fetchRequest = NSFetchRequest(entityName: "Post")
        fetchRequest.predicate = NSPredicate(format: "channel == %@", channel!)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                               managedObjectContext: managedObjectContext,
                                 sectionNameKeyPath: nil,
                                          cacheName: nil)
        
        fetchedResultsController.delegate = self

        var error: NSError? = nil
        if (!fetchedResultsController.performFetch(&error)) {
            println("Error: \(error?.localizedDescription)") }
        
       

    }
    override func viewWillAppear(animated: Bool) {
        // scrollToBottom(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return  fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as WallPostTableViewCell
        let post = fetchedResultsController.objectAtIndexPath(indexPath) as Post

        //cell.nameLabel.text = post.sender.firstName
        cell.wallPost.text = post.post
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .NoStyle

        cell.date.text = formatter.stringFromDate(post.date)
        return cell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenSize.width / 1.18
    }
    
    //MARK: NSFetchedResultsController Delegate methods
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        tableView.beginUpdates()
    }
    
    func controller ( controller: NSFetchedResultsController,
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
        scrollToBottom(true)
    }
   
    private func scrollToBottom(animated: Bool){
    
        let sectionInfo = fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
        if sectionInfo.numberOfObjects != 0 {
            
            let iPath = NSIndexPath(forRow: sectionInfo.numberOfObjects - 1,
                inSection: fetchedResultsController.sections!.count - 1)
            tableView.scrollToRowAtIndexPath(iPath, atScrollPosition: .Bottom, animated: animated)
        }
    }
   
    
    /*
    Self Sizing:
    */
    
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
