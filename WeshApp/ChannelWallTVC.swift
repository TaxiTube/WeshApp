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


    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHolder: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
      
        channelTitle.text = channel?.author.handle
        descriptionLabel.text = channel?.desc
//        descriptionLabel.sizeToFit()
       // headerViewHolder.sizeToFit()
        //headerView.sizeToFit()
        
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
        
        sizeHeaderToFit()
       

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
    /*
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenSize.width / 1.18
    }
    */
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
        scrollWallTo(true, animated: true)
    }
   
    func scrollWallTo(bottom:Bool, animated: Bool){
    
        let sectionInfo = fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
        if sectionInfo.numberOfObjects != 0 {
            var iPath: NSIndexPath?
            if bottom{
                
                 iPath = NSIndexPath(forRow: sectionInfo.numberOfObjects - 1,
                                     inSection: fetchedResultsController.sections!.count - 1)
                tableView.scrollToRowAtIndexPath(iPath!, atScrollPosition: .Bottom, animated: animated)

            } else{
                
                iPath = NSIndexPath(forRow: 0, inSection: 0)
                tableView.scrollToRowAtIndexPath(iPath!, atScrollPosition: .Top, animated: animated)
            }
        }
    }
    func scrollEntireTableTo(bottom: Bool, animated: Bool){
        if bottom{
            
            var yOffset: CGFloat  = 0.0
                    
            if (tableView.contentSize.height > tableView.bounds.size.height) {
                yOffset = tableView.contentSize.height - tableView.bounds.size.height
            }
                    
               tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentSize.height ), animated: animated)
         } else {
            
            tableView.setContentOffset(CGPoint(x: 0, y: 0 - tableView.contentInset.top), animated: animated)
        }

    }
    func sizeHeaderToFit(){
        
    var header = tableView.tableHeaderView!
    
    header.setNeedsLayout()
    header.layoutIfNeeded()
        
     var height = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
     var frm = header.frame
     
        frm.size.height = height
        header.frame = frm
        tableView.tableHeaderView = header
    }
    
    
//    override func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        <#code#>
//    }
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
}
