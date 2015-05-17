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
import BLKFlexibleHeightBar


class ChannelTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, WeshappUITextViewDelegate, PostCellDelegate {

    //MARK: NavBar properties
    private var myCustomBar: FlexibleNavBar?
    private var delegateSplitter: BLKDelegateSplitter?
   
    
    //MARK: Model CoreData stuff
    var channel: Channel?
    var fetchedResultsController : NSFetchedResultsController!
    var coreDataStack: CoreDataStack!
    let screenSize  = UIScreen.mainScreen().bounds.size
    var postMngr: PostMngr?
    var sessionMngr: SessionMngr?
    private let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate


    //MARK: InputAccessoryView stuff
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var inputAccessoryViewIsSetUp: Bool = false

    
    //MARK: InputAccessoryView outlets
    @IBOutlet weak var textView: WeshappTextView!
    @IBOutlet weak var accessoryDock: UIView!
    
    //MARK: TableView Header stuff
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var handle: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var totemButton: UIButton!
    @IBOutlet weak var channelDesc: UILabel!
    
    //TableView
    @IBOutlet weak var tableView: DockedTableView!
    
    @IBAction func totemPressed(sender: UIButton) {
        self.performSegueWithIdentifier("ChannelToProfile", sender: self)
    }
    


    
    @IBAction func postMessage(sender: AnyObject) {
    
        if textView.text != "" {
            let post = postMngr!.createPost(textView.text, channel: channel,
                                                              date: NSDate(),
                                                            sender: sessionMngr!.myBadge,
                                                            author: sessionMngr!.myBadge!.peerID)
            
            textView.text = ""
            //TODO: Decide whether after commenting on a channel wall, the channle persists -> Not from here
            //postsMngr!.save(coreDataStack!.mainContext!)
            sessionMngr!.broadcastNewPost(post)
            changeTextViewHeight(textView)
            //textView.resignFirstResponder()

        }
    }
    
    //TODO: add reverseGeoCode location
    private func getLocation()->String?{
        return nil
    }
    
    //MARK: ViewDid
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavBar()
        self.setUpHeaderView()
        
        self.tableView.registerNib(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
       
        //Inset required due to inputAccessoryView
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
            left: tableView.contentInset.left,
            bottom: view.frame.width / 7.2,
            right: tableView.contentInset.right)
        


        
        //Required for dynamic Cells
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //Set up model
        self.sessionMngr = self.appDelegate.sessionMngr
        self.coreDataStack = self.appDelegate.coreDataStack!
        

        //TODO: Move to New method
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
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

        //Create assign tableview its inputAccessoryView
        self.tableView.accessoryDock = self.accessoryDock
        self.tableView.becomeFirstResponder()
    }
    
    deinit {
        self.tableView.delegate = nil
        println("ChannelTVC dealloc")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUpNotifications()
    }
   
    override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
        self.tableView.flashScrollIndicators()
      
        
    }
    
    func showInputAccessoryView(sender: UIView){
        self.tableView.becomeFirstResponder()
    }
    
   override func viewDidLayoutSubviews() {
       self.updateViewConstraints()
        self.addBlur()
        if (!inputAccessoryViewIsSetUp && self.tableView.inputAccessoryView != nil){
            
            self.setUpInputAccessoryView()
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func addBlur(){
        
        self.tableView.backgroundColor = UIColor.clearColor()
        let backgroundImageView = UIImageView()
        self.tableView.backgroundView = backgroundImageView
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, tableView.bounds.width, tableView.bounds.height)
        backgroundImageView.addSubview(blurView)
    }
    

    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ChannelToProfile" {
            //                self.navigationController!.navigationBarHidden = true
            let profileVC = segue.destinationViewController as! ProfileVC
            //                channelVC.transitioningDelegate = self.transitionManager
            //                var channelVC = navController.topViewController as ChannelTVC
            let indexPath = self.tableView.indexPathForSelectedRow()
            // If as Channel else as Profile
            
            //let profile = currentFetchedRC.objectAtIndexPath(indexPath!) as Channel
            profileVC.badge = channel?.author
           // channelVC.coreDataStack = coreDataStack
           // channelVC.sessionMngr = sessionMngr
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
            
        } else if segue.identifier == "..."{
            
            var profileVC = segue.destinationViewController as! ProfileVC
            //                var profileVC = navController.topViewController as ProfileVC
            
            //                profileVC.transitioningDelegate = self.transitionManager
        }
    }

    //MARK: Navbar actions
    private func setUpNavBar(){
        self.setNeedsStatusBarAppearanceUpdate()
        // Setup the bar
//        leet maxHeight = screenSize.width / navbarProportion

        let frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 20.0)
        let channelTitleLabel = UILabel()
        
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                  NSFontAttributeName: font ]
        channelTitleLabel.attributedText = NSAttributedString(string: self.channel!.title,
                                                          attributes: titleDict)
        channelTitleLabel.sizeToFit()
      
        self.myCustomBar = FlexibleNavBar(frame: frame, centreItem: channelTitleLabel, rightItem: .Cross)
        
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
    
    


    func dismissPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func setUpHeaderView(){
        self.handle.titleLabel?.text = "#\(channel!.author.handle)"
        channelDesc.text = channel?.desc
        //TODO:profileName.text =
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Table view data source
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return  fetchedResultsController.sections!.count
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

  
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? WallPostTableViewCell
        let post = fetchedResultsController.objectAtIndexPath(indexPath) as! Post

        cell!.indexPath = indexPath
        cell!.delegate = self
//        cell!.handle.preferredMaxLayoutWidth = handle.bounds.size.width
        let authorHandle = sessionMngr!.getPostAuthor(post.author)
        cell!.handle.text = "#\(authorHandle)"
//         cell!.handle.sizeToFit()
//        cell!.handle.layoutIfNeeded()

        cell!.post?.text = post.post
        cell!.date?.text = timeAgoSinceDate(post.date, true)
        cell!.backgroundColor = UIColor.clearColor()
//        cell!.layoutSubviews()

  
        return cell!
    }
    
     func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    //MARK: NSFetchedResultsController Delegate methods
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller ( controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
           atIndexPath indexPath: NSIndexPath?,
              forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {
            
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            case .Update:
                let cell = tableView.cellForRowAtIndexPath(indexPath!) //as TeamCell
                //configureCell(cell, indexPath: indexPath)
            case .Move: tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                        tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            default: break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        scrollWallTo(true, animated: true)
    }
    //MARK: Post cell delegate
    func showProfilePressed(indexPath: NSIndexPath?) {
        println("index")   
        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.performSegueWithIdentifier("ChannelToProfile", sender: self)
    }
    
    //MARK: Scrolling stuff
    func scrollWallTo(bottom:Bool, animated: Bool){
    
        let sectionInfo = fetchedResultsController.sections![0] as! NSFetchedResultsSectionInfo
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
    //Used to setup and change default constraints height
    func setUpInputAccessoryView(){

        //Set Weshapp Delagete
        self.textView.weshappDelegate = self
        
        //Not sure when to use this:
        self.tableView.inputAccessoryView!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        var constraints:[NSLayoutConstraint] = self.tableView.inputAccessoryView!.constraints() as! Array
        //find default constraint
        for (c: NSLayoutConstraint) in constraints{
            if c.firstAttribute == NSLayoutAttribute.Height{
                c.constant = screenSize.width / 7.5
                 inputAccessoryViewIsSetUp = true
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

        self.tableView.inputAccessoryView!.addConstraint(self.textViewHeightConstraint!)
        self.tableView.updateConstraints()
        
       
    }
    
    //WeshappTextView Deleget method, called if textview number of lines change
    func textViewDidChangeHeight(textView: WeshappTextView) {
        changeTextViewHeight(textView)
    }
    
    //Finds accesoryview and textview constraints and changes there height according to the textview size
    private func changeTextViewHeight(textView: WeshappTextView){
        var max = CGFloat.max
        var sizeThatFitsTextView = self.textView.sizeThatFits(CGSizeMake(self.textView.frame.size.width, max ))
        
        var constraints:[NSLayoutConstraint] = self.tableView.inputAccessoryView!.constraints() as! Array
        
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
     self.tableView.layoutIfNeeded()
    }

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()


        if keyboardSize.height > 200{
            
            self.tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                left: tableView.contentInset.left,
                bottom: keyboardSize.height,
                right: tableView.contentInset.right)
            
            scrollWallTo(true, animated: true)
       
        }
        
    }
    func keyboardDidHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

        self.tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
            left: tableView.contentInset.left,
            bottom: view.frame.width / 7.2,
            right: tableView.contentInset.right)
    }
    
    
    
    func setUpNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("keyboardDidHide:"),
            name: UIKeyboardDidHideNotification,
            object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("showInputAccessoryView:"),
            name: "MenuDidHide",
            object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("dismissPressed:"),
            name: "SegueBack",
            object: nil)
        
    }
   
    
}
