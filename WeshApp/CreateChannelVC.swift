//
//  CreateChannelVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 25/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData
import WeshAppLibrary

class CreateChannelVC: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet weak var titleTV: UITextField!
    //@IBOutlet weak var descTV: BorderTextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var blurView: UIVisualEffectView!
     
    @IBOutlet weak var containerView: UIView!
       //MARK: Properties
    var appDelegate: AppDelegate {
       return UIApplication.sharedApplication().delegate! as AppDelegate
    }
    var coreDataStack: CoreDataStack?{
        return  appDelegate.coreDataStack
    }
    var sessionMngr: SessionMngr {
        return appDelegate.sessionMngr
    }
    var text: String = ""
    var placeHolderText: String = ""
     
     
    //MARK: Actions
    @IBAction func channelModalDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func goLive(sender: AnyObject) {
        /*
        let channelMngr = ChannelMngr(managedObjectContext: coreDataStack!.mainContext!,
                                             coreDataStack: coreDataStack!)
        
        let channel = channelMngr.createChannel(titleTV.text,
                                                    desc: descTV.text,
                                                    date: NSDate(),
                                                  author: sessionMngr.myBadge!)
       
        // photo: UIImageJPEGRepresentation(imageView.image, 0.5)
        // println(sessionMngr.myProfileMngr.insertChannel(sessionMngr.profile!, channel: <#Channel#>))
        // println(sessionMngr.profile!.channels.count)
        // channelMngr.save(coreDataStack!.mainContext!)
        
        sessionMngr.broadcastNewChannel(channel)
        */
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blur.frame = view.frame
        self.view.addSubview(blur)
        descTV.delegate = self
        placeHolderText = descTV.text
     }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = true

    }
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = false

    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        titleTV.resignFirstResponder()
        descTV.resignFirstResponder()
    }
    
    
    
    //MARK: textField delegate methods
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        titleTV.resignFirstResponder()
        descTV.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) -> Bool{
        
        descTV.text = text
        descTV.textColor = UIColor.blackColor()

        return true
    }
    //TODO: Placeholder colour changes after text entry
    func textViewDidEndEditing(textView: UITextView){
        text = descTV.text
        if text == "" {
            let grey80 = UIColor(white:0.80, alpha:1)

            titleTV.textColor = grey80
            titleTV.text = placeHolderText
         }
    }

    
}
