//
//  ChannelPageVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UIScrollViewDelegate, ChannelWallDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    //MARK: Properties
    var channel: Channel?
    var coreDataStack: CoreDataStack?
    var sessionMngr: SessionMngr?
    var postMngr: PostMngr?
    
    var navController: UINavigationController?
    var channelWallTVC: ChannelWallTVC?


    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    //MARK: IBOutlets
//    @IBOutlet weak var textField: UITextField!
    //@IBOutlet weak var containerView: UIView!
    //@IBOutlet weak var navigationBar: UINavigationItem!
    
    func hideKeyboard() {
//        textField.resignFirstResponder()
    }


    @IBAction func postMessage(sender: AnyObject) {
        
        if textView.text != "" {
            let post = postMngr!.createPost(textView.text, channel: channel,
                                                               date: NSDate(),
                                                             sender: sessionMngr!.myBadge)
            
            textView.text = ""
            //TODO: Decide whether after commenting on a channel wall, the channle persists
            //postsMngr!.save(coreDataStack!.mainContext!)
            sessionMngr!.broadcastNewPost(post)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("animateTextFieldWithKeyboard:"),
            name: UIKeyboardWillShowNotification,
            object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("animateTextFieldWithKeyboard:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "crossIcon.png"),
            style: .Done,
            target: self,
            action: "dismissPressed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburgerIcon.png"),
            style: .Done,
            target: self,
            action: "dismissPressed:")
        self.navigationItem.title = channel?.title

        
        postMngr = PostMngr(managedObjectContext: coreDataStack!.mainContext!,
                                   coreDataStack: coreDataStack!)

        
    }
   
    override func viewDidAppear(animated: Bool) {
        navController = navigationController

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toChannelWallVC" {
            channelWallTVC = segue.destinationViewController as? ChannelWallTVC
            channelWallTVC?.delegate = self
            channelWallTVC?.channel = channel
        }
    }
   

    //MARK: Keyboard
    func animateTextFieldWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as UInt
        
        // baseContraint is your Auto Layout constraint that pins the
        // text view to the bottom of the superview.
//        let screenHeight  = UIScreen.mainScreen().bounds.size.height - navController!.navigationBar.frame.height
        let offset =  keyboardSize.height
        println("hey")
        if notification.name == UIKeyboardWillShowNotification{

//            
//            bottomConstraint.constant = keyboardSize.height
//
//            bottomConstraint.constant = bottomConstraint.constant + offset  // move up
//            topConstraint.constant =  -offset
            channelWallTVC?.scrollEntireTableTo(true, animated: true)
            navigationController?.setNavigationBarHidden(true, animated: true)
            
            UIApplication.sharedApplication().statusBarHidden = true
            
        }
        else {
//            bottomConstraint.constant = 0 // move down
//            topConstraint.constant = 0
            channelWallTVC?.scrollEntireTableTo(false, animated: true)
            navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIApplication.sharedApplication().statusBarHidden = false
        }
        view.setNeedsUpdateConstraints()
        
        let options = UIViewAnimationOptions(curve << 16)
        UIView.animateWithDuration(duration, delay: 0, options: options,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
 
    //MARK: Navbar actions
    func dismissPressed(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
  }
