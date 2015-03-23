
//  ChannelWallTVC.swift
//  WeshApp
//
//  Created by rabzu on 21/12/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import CoreData
import WeshAppLibrary
import Designables


class ChannelTVC: UITableViewController, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, WeshappUITextViewDelegate {

    var channel: Channel?
    var fetchedResultsController : NSFetchedResultsController!
    var coreDataStack: CoreDataStack!
    let screenSize  = UIScreen.mainScreen().bounds.size
    var postMngr: PostMngr?
    var sessionMngr: SessionMngr?

    var textViewHeightConstraint: NSLayoutConstraint?
    private var inputAccessoryViewIsSetUp: Bool = false

    @IBOutlet weak var textView: WeshappTextView!
    @IBOutlet var accessoryDock: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var totem: UIImageView!
    @IBOutlet weak var channelDesc: WeshappLabel!
    
    
    @IBAction func postMessage(sender: AnyObject) {
    
        if textView.text != "" {
            let post = postMngr!.createPost(textView.text, channel: channel,
                                                                   date: NSDate(),
                                                                 sender: sessionMngr!.myBadge)
    
            textView.text = ""
            //TODO: Decide whether after commenting on a channel wall, the channle persists
            //postsMngr!.save(coreDataStack!.mainContext!)
            sessionMngr!.broadcastNewPost(post)
            changeTextViewHeight(textView)
            //textView.resignFirstResponder()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpHeaderView()
        self.navBarItemsSetup()
//        self.shyNavBarManager.scrollView = self.tableView
     
        self.tableView.registerNib(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
                                                          selector: Selector("keyboardWillShow:"),
                                                              name: UIKeyboardWillShowNotification,
                                                            object: nil)
       
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("keyboardDidHide:"),
            name: UIKeyboardDidHideNotification,
            object: nil)
     

        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                             left: tableView.contentInset.left,
                                           bottom: view.frame.width / 7.2,
                                            right: tableView.contentInset.right)

   
        let appDelegate = UIApplication.sharedApplication().delegate! as AppDelegate
        coreDataStack = appDelegate.coreDataStack!
        let managedObjectContext = appDelegate.coreDataStack!.mainContext!
        let fetchRequest = NSFetchRequest(entityName: "Post")
        fetchRequest.predicate = NSPredicate(format: "channel == %@", channel!)
        
        postMngr = PostMngr(managedObjectContext: coreDataStack!.mainContext!,
                                   coreDataStack: coreDataStack!)
        
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
            println("Error: \(error?.localizedDescription)")
        }

        

        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        
        tableView.backgroundColor = UIColor.clearColor()
        let backgroundImageView = UIImageView()
         tableView.backgroundView = backgroundImageView
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, tableView.bounds.width, tableView.bounds.height)
        backgroundImageView.addSubview(blurView)
        
   }
   
    override func viewWillAppear(animated: Bool) {
//        self.setNeedsStatusBarAppearanceUpdate()
//        tableView.setContentOffset(CGPointMake(0.0, -5), animated: true)

    }
    
    override func viewDidAppear(animated: Bool) {
//        scrollWallTo(true, animated: true)
      //  scrollWallTo(false, animated: true)
        
       // tableView.setContentOffset(CGPointMake(0.0, 0), animated: true)
       // tableView.scrollRectToVisible(CGRect(x: 0, y: 100, width: 1, height: 1), animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        if (!inputAccessoryViewIsSetUp && tableView.inputAccessoryView? != nil){
            self.setUpInputAccessoryView()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    //MARK: Navbar actions
    private func navBarItemsSetup(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "crossIcon.png"),
            style: .Done,
            target: self,
            action: "dismissPressed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburgerIcon.png"),
            style: .Done,
            target: self,
            action: "dismissPressed:")

        self.navigationItem.title = channel?.title
    }
    

    func dismissPressed(sender: AnyObject) {
        //        navigationController?.popToRootViewControllerAnimated(true)
        NSOperationQueue.mainQueue().addOperationWithBlock(){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func setUpHeaderView(){
        handle.text = "#\(channel!.author.handle)"
        channelDesc.text = channel?.desc
//        profileName.text =
        
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
        cell.post?.text = post.post
        cell.date?.text = timeAgoSinceDate(post.date, true)
        cell.backgroundColor = UIColor.clearColor()
  
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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
        scrollWallTo(true, animated: true)
    }
    
    //MARK: Scrolling stuff
    func scrollWallTo(bottom:Bool, animated: Bool){
    
        let sectionInfo = fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
        if sectionInfo.numberOfObjects != 0 {
            var iPath: NSIndexPath?
            if bottom{
                
                 iPath = NSIndexPath(   forRow: sectionInfo.numberOfObjects - 1,
                                     inSection: fetchedResultsController.sections!.count - 1)
                tableView.scrollToRowAtIndexPath(iPath!, atScrollPosition: .Bottom, animated: animated)

            } else{
                
                iPath = NSIndexPath(forRow: 0, inSection: 0)
                tableView.scrollToRowAtIndexPath(iPath!, atScrollPosition: .Top, animated: animated)
            }
        }
     }
    //MARK: Dynamic UITableViewHeader height calculation
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.headerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        var headerWidth = self.headerView.bounds.size.width
        var temporaryWidthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[headerView(width)]",
            options: nil,
            metrics:["width": headerWidth],
            views:["headerView": self.headerView])
        
        self.headerView.addConstraints(temporaryWidthConstraints)
        sizeHeaderToFit()
        self.headerView.removeConstraints(temporaryWidthConstraints)
        self.headerView.setTranslatesAutoresizingMaskIntoConstraints(true)
    }
    
    private func sizeHeaderToFit(){
        var header = tableView.tableHeaderView!
        header.setNeedsLayout()
        header.layoutIfNeeded()
        var height = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frm = header.frame
        frm.size.height = height
        header.frame = frm
        tableView.tableHeaderView = header
    }
    
   
    //MARK: InputAccessoryView
    //Return your custom input accessory view
    override var inputAccessoryView: UIView! {
        return accessoryDock
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    //Used to setup and chang default constraints height
    func setUpInputAccessoryView(){

        //Set Weshapp Delagete
        textView.weshappDelegate = self
        
        //Not sure when to use this: tableView.inputAccessoryView!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        var constraints:[NSLayoutConstraint] = tableView.inputAccessoryView!.constraints() as Array
        //find default constraint
        for (c: NSLayoutConstraint) in constraints{
            if c.firstAttribute == NSLayoutAttribute.Height{
                c.constant = screenSize.width / 7.5
                break
            }
        }
        //Add text view height constrain
        textViewHeightConstraint = NSLayoutConstraint(item: self.textView,
                                              attribute: NSLayoutAttribute.Height,
                                              relatedBy: NSLayoutRelation.Equal,
                                                 toItem: nil,
                                              attribute: NSLayoutAttribute.NotAnAttribute,
                                             multiplier: 1,
                                               constant: (screenSize.width / 7.5))

        tableView.inputAccessoryView!.addConstraint(self.textViewHeightConstraint!)
        tableView.updateConstraints()
        
        inputAccessoryViewIsSetUp = true
    }
    
    //WeshappTextView Deleget method, called if textview number of lines change
    func textViewDidChangeHeight(textView: WeshappTextView) {
        changeTextViewHeight(textView)
    }
    
    //Finds accesoryview and textview constraints and changes there height according to the textview size
    private func changeTextViewHeight(textView: WeshappTextView){
        var max = CGFloat.max
        var sizeThatFitsTextView = self.textView.sizeThatFits(CGSizeMake(self.textView.frame.size.width, max ))
        
        var constraints:[NSLayoutConstraint] = tableView.inputAccessoryView!.constraints() as Array
        
        for  (c: NSLayoutConstraint) in constraints{
            if c.firstAttribute == NSLayoutAttribute.Height {
                
                if textView.numberOfLines() > 1{
                    UIView.animateWithDuration(0.5){
                    
                        self.textViewHeightConstraint!.constant = sizeThatFitsTextView.height
                        c.constant = sizeThatFitsTextView.height
                    }
                    break
                } else if textView.numberOfLines() == 1{
                    self.textViewHeightConstraint!.constant = self.screenSize.width / 7.5
                    c.constant = self.screenSize.width / 7.5 
                    
                }
                
            }
        }
     tableView.layoutIfNeeded()
    }

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()


        if keyboardSize.height > 200{
            
            tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                left: tableView.contentInset.left,
                bottom: keyboardSize.height,
                right: tableView.contentInset.right)
            
            scrollWallTo(true, animated: true)
       
        }
        
    }
    func keyboardDidHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()

        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
            left: tableView.contentInset.left,
            bottom: view.frame.width / 7.2,
            right: tableView.contentInset.right)
    }
    
   
    
}
