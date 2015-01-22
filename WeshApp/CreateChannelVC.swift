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
import Designables

class CreateChannelVC: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTF: UITextField!
    //@IBOutlet weak var descTV: BorderTextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTV: UITextView!
   // @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var handleLable: UILabel! 
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
    var placeHolderTextTV: String = ""
    
     
    //MARK: Actions
    
    @IBAction func goLive(sender: AnyObject) {
        UIApplication.sharedApplication().statusBarHidden = false

        let channelMngr = ChannelMngr(managedObjectContext: coreDataStack!.mainContext!,
                                             coreDataStack: coreDataStack!)
        if titleTF.text != "" {
            let channel = channelMngr.createChannel(titleTF.text,
                desc: descTV.text,
                date: NSDate(),
                author: sessionMngr.myBadge!)
            sessionMngr.broadcastNewChannel(channel)
        }
        dismissViewControllerAnimated(true, completion: nil)

    }
    override func viewWillAppear(animated: Bool) {
        
        //TODO: Move image processing else where
        
       
      //  imageView.image = getTotemImage()
        
        
        //TODO: get totem image from the array
        handleLable.text = "#" + sessionMngr.myBadge!.handle
        handleLable.adjustsFontSizeToFitWidth = true
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(     self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlur()
        descTV.delegate = self
        titleTF.delegate = self
        placeHolderTextTV = descTV.text
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: CrossBarItem())

       
        /*
        var constraints = [NSLayoutConstraint]()

        constraints.append(NSLayoutConstraint(item: barButtonItem,
            attribute: .Height, relatedBy: .Equal, toItem: view,
            attribute: .Height, multiplier: 0.06, constant: 0))
        constraints.append(NSLayoutConstraint(item: barButtonItem,
            attribute: .Width, relatedBy: .Equal, toItem: view,
            attribute: .Width, multiplier: 0.04, constant: 0))
        view.addConstraints(constraints)
        */
    }
    

    
    
   /*
    func getTotemImage()-> UIImage{
    
        
        //Create Context
        let context = CIContext(options:nil)
        //Convert the UIImage to a CGImage object, which is needed for the Core Graphics calls. Also, get the image’s width and height.
        let faceImage = CIImage(image: UIImage(named: "Lion"))
        let wallpaperImage = CIImage(image: UIImage(named: "Orange"))
        
       // let totemImage = compositeSourceOver(wallpaperImage)(faceImage)
       
        return UIImage(CIImage: totemImage)!
    }
    */
    
    
    func dismissPressed(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
       // UIApplication.sharedApplication().statusBarHidden = true

    }
    override func viewWillDisappear(animated: Bool) {
       // UIApplication.sharedApplication().statusBarHidden = false

    }
    
       @IBAction func onTap(sender: AnyObject) {
        titleTF.resignFirstResponder()
          self.view.endEditing(true)
        descTV.resignFirstResponder()
    }

  //MARK: UITextField delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        return true;
    }
    
    
    //MARK: Blur
    
    private func addBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
       

        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.insertSubview(blurView, atIndex: 0)
        //view.sendSubviewToBack(blurView)
        
        
        
        var constraints = [NSLayoutConstraint]()
        //Size constraints
        constraints.append(NSLayoutConstraint(item: blurView,
            attribute: .Height, relatedBy: .Equal, toItem: view,
            attribute: .Height, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: blurView,
            attribute: .Width, relatedBy: .Equal, toItem: view,
            attribute: .Width, multiplier: 1, constant: 0))
        //Center alignment
        constraints.append(NSLayoutConstraint(item: blurView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: blurView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        
        view.addConstraints(constraints)
        
    }
    
    //MARK: textField delegate methods
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        titleTF.resignFirstResponder()
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

            descTV.textColor = grey80
            descTV.text = placeHolderTextTV
         }
    }
    
    //MARK: View scrolling
    func keyboardWillShow(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let s: NSValue = info.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue;
        let keyboardRect :CGRect = s.CGRectValue();
        var containerViewOrigin = containerView.frame.origin
        var containerViewHeight = containerView.frame.size.height
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardRect.height
        
        
            var scrollPoint = CGPointMake(0.0, containerViewOrigin.y - visibleRect.size.height + containerViewHeight);
            scrollView.setContentOffset(scrollPoint, animated: true)
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        scrollView.setContentOffset(CGPointZero, animated:true)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
}


typealias Filter = CIImage -> CIImage
typealias Parameters = Dictionary<String, AnyObject>

extension CIFilter {
    convenience init(name: String, parameters: Parameters){
        self.init(name:name)
        setDefaults()
        for(key, value: AnyObject) in parameters{
            setValue(value, forKey: key)
        }
    }
    var outputImage: CIImage{
        return self.valueForKey(kCIOutputImageKey) as CIImage
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter{
    
    return { image in
        
        let parameters: Parameters = [
        "InputImage": image,
            "inputBackgroundImage": image
        ]
        let filter = CIFilter(name:"CISourceAtopCompositing", parameters: parameters)
        let cropRect = image.extent()
        
        return filter.outputImage.imageByCroppingToRect(cropRect)
        
        
        
    }
    
}
