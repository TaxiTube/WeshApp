//
//  ChannelPageVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

class ChannelPageVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    
    var channel: Channel?
    var coreDataStack: CoreDataStack?
    var sessionMngr: SessionMngr?
    var transcriptMngr: TranscriptMngr?
    
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
  
   @IBAction func hideKeyboard(sender: AnyObject) {
     textField.resignFirstResponder()
    }
    
    
    @IBAction func postMessage(sender: AnyObject) {
        
        if textField.text != "" {
        

            let transcript = transcriptMngr!.createTranscript(textField.text,
                                                                  channel: channel,
                                                                     date: NSDate(),
                                                                   sender: sessionMngr!.myBadge)
            
            textField.text = ""
            //TODO: Decide whether after commenting on a channel wall, the channle persists
            //transcriptMngr!.save(coreDataStack!.mainContext!)
            sessionMngr!.broadcastNewTranscript(transcript)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         transcriptMngr = TranscriptMngr(managedObjectContext: coreDataStack!.mainContext!,
            coreDataStack: coreDataStack!)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChannelContainerSegue" {
            let channelWallTVC = segue.destinationViewController as ChannelWallTVC
            channelWallTVC.channel = channel
        }
    }

    override func viewWillAppear(animated: Bool) {
        
            NSNotificationCenter.defaultCenter().addObserver(     self,
                                                        selector: Selector("keyboardWillShow:"),
                                                            name: UIKeyboardWillShowNotification,
                                                          object: nil);
        
            NSNotificationCenter.defaultCenter().addObserver(     self,
                                                        selector: Selector("keyboardWillHide:"),
                                                            name: UIKeyboardWillHideNotification,
                                                          object: nil)
    }
    
 
    
    func keyboardWillShow(notification: NSNotification) {
            let info: NSDictionary = notification.userInfo!
            let s: NSValue = info.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue;
            let keyboardRect :CGRect = s.CGRectValue();
            var containerViewOrigin = containerView.frame.origin
            var containerViewHeight = containerView.frame.size.height
            var visibleRect = self.view.frame
            visibleRect.size.height -= keyboardRect.height
        
            if (!CGRectContainsPoint(visibleRect, containerViewOrigin)){
                var scrollPoint = CGPointMake(0.0, containerViewOrigin.y - visibleRect.size.height + containerViewHeight);
                scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
 
    func keyboardWillHide(sender: NSNotification) {
             scrollView.setContentOffset(CGPointZero, animated:true)
    }
  
    
  }
