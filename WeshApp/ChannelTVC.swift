
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


class ChannelTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, WeshappUITextViewDelegate {

    //MARK: NavBar properties
    private var myCustomBar: FlexibleNavBar?
    private var delegateSplitter: BLKDelegateSplitter?
    private let navbarProportion: CGFloat = 4.87
    
    //MARK: Model CoreData stuff
    var channel: Channel?
    var fetchedResultsController : NSFetchedResultsController!
    var coreDataStack: CoreDataStack!
    let screenSize  = UIScreen.mainScreen().bounds.size
    var postMngr: PostMngr?
    var sessionMngr: SessionMngr?

    //MARK: InputAccessoryView stuff
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var inputAccessoryViewIsSetUp: Bool = false

    
    //MARK: InputAccessoryView outlets
    @IBOutlet weak var textView: WeshappTextView!
    @IBOutlet var accessoryDock: UIView!
    
    //MARK: TableView Header stuff
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var totem: UIImageView!
    @IBOutlet weak var channelDesc: UILabel!
    
    //TableView
    @IBOutlet weak var tableView: DockedTableView!
    
    
    
    
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
        

        
        NSNotificationCenter.defaultCenter().addObserver(     self,
                                                          selector: Selector("keyboardWillShow:"),
                                                              name: UIKeyboardWillShowNotification,
                                                            object: nil)
       
        NSNotificationCenter.defaultCenter().addObserver(     self,
                                                         selector: Selector("keyboardDidHide:"),
                                                             name: UIKeyboardDidHideNotification,
                                                           object: nil)
        //Required for dynamic Cells
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableViewAutomaticDimension
        

        //TODO: Move to New method
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

        
        self.tableView.accessoryDock = self.accessoryDock
        self.tableView.becomeFirstResponder()

        self.tableView.backgroundColor = UIColor.clearColor()
        let backgroundImageView = UIImageView()
        self.tableView.backgroundView = backgroundImageView
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, tableView.bounds.width, tableView.bounds.height)
        backgroundImageView.addSubview(blurView)
        
   }
    
    deinit {
        println("dealloc")
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    override func viewDidAppear(animated: Bool) {
      
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
       self.updateViewConstraints()
        if (!inputAccessoryViewIsSetUp && self.tableView.inputAccessoryView? != nil){
            
            self.setUpInputAccessoryView()
            
        }
    }
    
    
    
    //MARK: menu
    func showMenu(sender: UIView) {
        NSNotificationCenter.defaultCenter().postNotificationName("ShowMenu", object: self)
    }
    
    
    //MARK: Navbar actions
    private func setUpNavBar(){
        self.setNeedsStatusBarAppearanceUpdate()
        // Setup the bar
        let maxHeight = screenSize.width / navbarProportion

        let frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 20.0)
        let channelTitleLabel = UILabel()
        
        let font = UIFont(name: "TitilliumText25L-250wt", size: 19.0)!
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                  NSFontAttributeName: font ]
        channelTitleLabel.attributedText = NSAttributedString(string: self.channel!.title,
                                                          attributes: titleDict)
        channelTitleLabel.sizeToFit()
        
        //Menu Burger Item
        let burgerWidthProp: CGFloat = 0.05
        let burgerHeightToWidth: CGFloat = 21.91
        let burgerframe = CGRectMake(20, 20, screenSize.width * burgerWidthProp,
            screenSize.width / burgerHeightToWidth)
       let burgerItem = BurgerItem(frame: burgerframe)
        burgerItem.addTarget(self, action: "showMenu:", forControlEvents: .TouchUpInside)
    

        //Plus item
        //Sqaure size
        let crossWidthProp: CGFloat = 19.1025
        let crossframe = CGRectMake(20, 20, screenSize.width / crossWidthProp,
                                            screenSize.width / crossWidthProp)
        let crossItem = CrossItem(frame: crossframe)
        crossItem.addTarget(self, action: "dismissPressed:", forControlEvents: .TouchUpInside)
      
        
        self.myCustomBar = FlexibleNavBar(frame: frame, max: maxHeight , min: CGFloat(20), leftItem: burgerItem, centreItem: channelTitleLabel, rightItem: crossItem)
        
        var behaviorDefiner = FacebookStyleBarBehaviorDefiner()
        behaviorDefiner.addSnappingPositionProgress( 0.0, forProgressRangeStart: 0.0, end: 0.5)
        behaviorDefiner.addSnappingPositionProgress( 1.0, forProgressRangeStart: 0.5, end: 1.0)
        behaviorDefiner.snappingEnabled = false
        
        self.myCustomBar?.behaviorDefiner = behaviorDefiner
        
        //Assigns tow delegates
        self.delegateSplitter = BLKDelegateSplitter(firstDelegate: behaviorDefiner, secondDelegate: self)
        self.tableView.delegate =  self.delegateSplitter
        
        self.view.addSubview(self.myCustomBar!)
        self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar!.maximumBarHeight - 20, 0.0, 0.0, 0.0)
    }
    
    


    func dismissPressed(sender: AnyObject) {
                navigationController?.popViewControllerAnimated(true)
//        NSOperationQueue.mainQueue().addOperationWithBlock(){
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }
    
    private func setUpHeaderView(){
        handle.text = "#\(channel!.author.handle)"
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
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

  
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? WallPostTableViewCell
        let post = fetchedResultsController.objectAtIndexPath(indexPath) as Post

        //cell.nameLabel.text = post.sender.firstName
        cell!.post?.text = post.post
        cell!.date?.text = timeAgoSinceDate(post.date, true)
        cell!.backgroundColor = UIColor.clearColor()
  
        return cell!
    }
    
     func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    //Used to setup and change default constraints height
    func setUpInputAccessoryView(){

        //Set Weshapp Delagete
        self.textView.weshappDelegate = self
        
        //Not sure when to use this: 
        self.tableView.inputAccessoryView!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        var constraints:[NSLayoutConstraint] = self.tableView.inputAccessoryView!.constraints() as Array
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
        
        var constraints:[NSLayoutConstraint] = self.tableView.inputAccessoryView!.constraints() as Array
        
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
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()


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
        var keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()

        self.tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
            left: tableView.contentInset.left,
            bottom: view.frame.width / 7.2,
            right: tableView.contentInset.right)
    }
    
   
    
}
