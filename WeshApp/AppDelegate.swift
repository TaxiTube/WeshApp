 //
//  AppDelegate.swift
//  WeshApp
//
//  Created by z.kakabadze on 23/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import WeshAppLibrary
 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreDataStack: CoreDataStack? = CoreDataStack()
    var sessionMngr: SessionMngr!
   

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

             
        if let cds = coreDataStack {
            
            // Check if we are running as test or not
            let environment = NSProcessInfo.processInfo().environment as! [String : AnyObject]
            let isTest = (environment["XCInjectBundle"] as? String)?.pathExtension == "xctest"
            // Create the module name
            if !isTest{
                sessionMngr = SessionMngr(coreDataStack: cds)
            }else{
              
                var storyboard = UIStoryboard(name:"Main", bundle:NSBundle(forClass: self.dynamicType))
                var vc = storyboard.instantiateViewControllerWithIdentifier("SplashVC") as! UIViewController
                vc.loadView()
                // Set root view controller and make windows visible
                //window = UIWindow(frame:UIScreen.mainScreen().bounds)
               window!.rootViewController = vc
               window!.makeKeyAndVisible()  
               return true
            }
          //sessionMngr = SessionMngr(coreDataStack: cds)
          
        UILabel.appearance().substituteFontName =   "TitilliumText25L-250wt"
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent,
                                                  animated: false)
     
        } else {
            abort()
        }
      
        return true
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("applicationDidEnterBackground")
        coreDataStack!.saveContext(coreDataStack!.mainContext!)

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        println("applicationWillTerminate")
        coreDataStack!.saveContext(coreDataStack!.mainContext!)
    }

   
}
 extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
 }
