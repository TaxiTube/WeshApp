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

class CreateChannelVC: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: WeshappRedButton!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var handleLable: UILabel!

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
    var placeHolderTF: String = ""
     
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
            //sessionMngr.broadcastNewChannel(channel)
        }
        channelMngr.save(coreDataStack!.mainContext!)
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func onTap(sender: AnyObject) {
        titleTF.resignFirstResponder()
        self.view.endEditing(true)
        descTV.resignFirstResponder()
    }
    
    //MARK: Initialisation
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
        
        //imageView.image = getTotemImage()
        //TODO: get totem image from the array
        
        handleLable.text = "#" + sessionMngr.myBadge!.handle
        addBlur()
        descTV.delegate = self
        titleTF.delegate = self
        placeHolderTextTV = descTV.text
        placeHolderTF = titleTF.placeholder!
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "crossIcon.png"),
                                                                 style: .Done,
                                                                target: self,
                                                                action: "dismissPressed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburgerIcon.png"),
                                                                style: .Done,
                                                               target: self,
                                                               action: "dismissPressed:")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       //navigationController?.hidesBarsWhenKeyboardAppears = true
      //  navigationController?.hidesBarsOnTap = true
    
    }
    override func viewDidDisappear(animated: Bool) {
       // navigationController?.hidesBarsWhenKeyboardAppears = false
         //        navigationController?.hidesBarsOnTap = false
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)

    }
    
    func dismissPressed(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
 
    
    //MARK: Image Processing
    func getTotemImage()-> UIImage{
        
        //Convert the UIImage to a CGImage object, which is needed for the Core Graphics calls. Also, get the image’s width and height.
        let faceImage = CIImage(image: UIImage(named: "Lion"))
        let wallpaperImage = CIImage(image: UIImage(named: "Orange"))
        
        let totemImage = WeshappFilters.compositeSourceOver(wallpaperImage)(faceImage)
        
        //return UIImage(CIImage: filter.outputImage)!
        return WeshappFilters.roundImage(UIImage(CIImage: totemImage)!)
    }
    
    //MARK: Blur
    private func addBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
       

        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.insertSubview(blurView, atIndex: 0)
        
        self.view.layoutMargins = UIEdgeInsetsZero
        
        button.layoutMargins = UIEdgeInsetsZero
        blurView.layoutMargins = UIEdgeInsetsZero
       
        let viewsDictionary = ["top":topLayoutGuide,"bottom":button, "blur": blurView]

        //Margin constraints
        let vConstraints: NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[blur]-(-8)-[bottom]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let hConstraints: NSArray =  NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-8)-[blur]-(-8)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
       
        view.addConstraints(vConstraints)
        view.addConstraints(hConstraints)
        
        view.layoutIfNeeded()
        
    }
    
    //MARK: TextField delegate methods
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        titleTF.resignFirstResponder()
        descTV.resignFirstResponder()
        return true
    }
   
  
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text as NSString
        let newString = oldString.stringByReplacingCharactersInRange(range, withString: string) as NSString
        let stringSize = newString.sizeWithAttributes([NSFontAttributeName:textField.font])
        return stringSize.width < textField.editingRectForBounds(textField.bounds).size.width
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        titleTF.placeholder = nil
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        titleTF.placeholder = placeHolderTF
    }
    
    //MARK: TextView
    func textViewDidBeginEditing(textView: UITextView) -> Bool{
        
        descTV.text = text
        descTV.textColor = UIColor.blackColor()
        
        return true
    }
    func textViewDidEndEditing(textView: UITextView){
        text = descTV.text
        if text == "" {
            let grey80 = UIColor(white:0.80, alpha:1)

            descTV.textColor = grey80
            descTV.text = placeHolderTextTV
         }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        return true
    }
   
  
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
       return descTV.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) + text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 300
    }

    

    //MARK: Keyboard
    func animateTextFieldWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as UInt
            
        // baseContraint is your Auto Layout constraint that pins the
        // text view to the bottom of the superview.
        let screenHeight  = UIScreen.mainScreen().bounds.size.height - navigationController!.navigationBar.frame.height
        let offset = (descTV.frame.origin.y + descTV.frame.height) - (screenHeight - keyboardSize.height)
     
        if notification.name == UIKeyboardWillShowNotification && offset > 0 {
            bottomConstraint.constant =   bottomConstraint.constant + offset  // move up
           navigationController?.setNavigationBarHidden(true, animated: true)

            UIApplication.sharedApplication().statusBarHidden = true

        }
        else {
            bottomConstraint.constant = 0 // move down
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
 
}
    
    /*
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
    */
    /*
    func adjustFontSize(label: UILabel, text: String) {
        let maxFontSize = 50.0
        var tmpRange = NSMakeRange(0, countElements(text))
        var paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.alignment = NSTextAlignment.Center
        paragraph.maximumLineHeight = CGFloat(maxFontSize)
        paragraph.lineSpacing = 0;

        var attString = NSMutableAttributedString(string: text)
        attString.addAttribute( NSParagraphStyleAttributeName,
                              value: paragraph,
                              range: tmpRange)
        attString.addAttribute(NSForegroundColorAttributeName,
                    value: UIColor.blackColor(),
                    range: tmpRange)

        var constraintSize = CGSizeMake(label.frame.size.width, CGFloat.max);

        for var i = maxFontSize; i > 8; i - 1 {

        attString.addAttribute(NSFontAttributeName, value: UIFont(name: "TitilliumText25L-250wt", size: CGFloat(i))!, range: tmpRange)


        label.attributedText = attString

        var labelSize = label.attributedText.boundingRectWithSize(constraintSize,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            context: nil)

            if(labelSize.size.height < label.frame.size.height){

                break
            }
        }
    }
    */




