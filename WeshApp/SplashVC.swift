//
//  SplashVC.swift
//  WeshApp
//
//  Created by z.kakabadze on 23/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//
import UIKit
import AVKit
import AVFoundation

import CoreData
import WeshAppLibrary


class SplashVC: UIViewController {
    
  
    private var appDelegate: AppDelegate{
        return UIApplication.sharedApplication().delegate! as AppDelegate
    }
    @IBOutlet weak var handleTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func continueAction(sender: AnyObject) {
        
        if handleTextField.text != "" {
            println(handleTextField.text)
             appDelegate.sessionMngr.setUpConnection(handleTextField.text)
            //replace with toTotem
            NSUserDefaults.standardUserDefaults().setObject(handleTextField.text, forKey: "handle")
            NSUserDefaults.standardUserDefaults().synchronize()
            println(NSUserDefaults.standardUserDefaults().dataForKey("handle"))

            self.performSegueWithIdentifier("toChannels", sender:self)
        }
    }
    
     
    
    
    
//    @IBOutlet weak var signInView: UIView!
  //  var playerLayer:AVPlayerLayer!
    
    override func viewWillAppear(animated: Bool) {
        
        //Create peerID if one does not exist else retrive it from object graph model
      
        if let handle = NSUserDefaults.standardUserDefaults().stringForKey("handle"){
            println("here")
           appDelegate.sessionMngr.setUpConnection(handleTextField.text)
              
            
            
        }else{
             containerView.hidden = false
        }
    }
    override func viewDidLoad() {
        
    }
        
    
        
        
        
   /*
        //UIApplication.sharedApplication().statusBarHidden = true
        let url = NSBundle.mainBundle().URLForResource("splash", withExtension: "mp4")
        
        var asset: AVAsset = AVAsset.assetWithURL(url) as AVAsset
        var playerItem = AVPlayerItem(asset: asset)
        var player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player:player)
        playerLayer!.frame = self.view.frame
        self.view.layer.addSublayer(playerLayer!)
        player.play()
        
         NSTimer.scheduledTimerWithTimeInterval(0.1,
                                                target: self,
                                              selector: Selector("destruct"),
                                              userInfo: nil,
                                               repeats: false)
        

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toChannels" {
            let localChannel = segue.destinationViewController as ChannelPageVC
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            let channel = fetchedResultsController.objectAtIndexPath(indexPath!) as Channel
            channelPageVC.channel = channel
            channelPageVC.coreDataStack = coreDataStack
            channelPageVC.sessionMngr = sessionMngr
        }
        
    }
    */
    
    func destruct(){
       // self.performSegueWithIdentifier("toTotem", sender:self)
      // playerLayer!.removeFromSuperlayer()
        //signInView.hidden = false

    }
     func viewDidDisappear(){
        println("destruct")
        destruct()
    }
   
    

}
