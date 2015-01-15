//
//  CoreDataStack.swift
//  WeshApp
//
//  Created by rabzu on 10/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    public init() {
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "io.WeshApp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    
    /*
    Depending if you are running as App vs Tests the issue can be that the app is looking for <appName>.<entityName> and when it's running as test it's looking as <appName>Tests.<entityName>. The solution I use at this time (Xcode 6.1) is to NOT fill the Class field in the CoreData UI, and to do it in code instead.
    
    This code will detect if you are running as App vs Tests and use the right module name and update the managedObjectClassName
    */
    public lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional...
        let modelURL = NSBundle.mainBundle().URLForResource("WeshApp", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        // Check if we are running as test or not
        let environment = NSProcessInfo.processInfo().environment as [String : AnyObject]
        let isTest = (environment["XCInjectBundle"] as? String)?.pathExtension == "xctest"
        
        // Create the module name
        let moduleName = (isTest) ? "WeshAppTests" : "WeshApp"
        
        // Create a new managed object model with updated entity class names
        var newEntities = [] as [NSEntityDescription]
        for (_, entity) in enumerate(managedObjectModel.entities) {
            let newEntity = entity.copy() as NSEntityDescription
            newEntity.managedObjectClassName = "\(moduleName).\(entity.name)"
            newEntities.append(newEntity)
        }
        let newManagedObjectModel = NSManagedObjectModel()
        newManagedObjectModel.entities = newEntities
        
        return newManagedObjectModel
        }()
    
 
    
    // MARK: - Core Data stack
    
    
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(
                                                            managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("WeshApp.sqlite")
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if nil == coordinator!.addPersistentStoreWithType(NSSQLiteStoreType,
                                                        configuration: nil,
                                                                  URL: url,
                                                              options: nil,
                                                                error: &error){
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    public lazy var rootContext: NSManagedObjectContext? = {
        
        var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }()
    
    // Returns the managed object context for the application
    public lazy var mainContext: NSManagedObjectContext? = {
        
        var mainContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.parentContext = self.rootContext
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                  selector: "mainContextDidSave:",
                                                      name: NSManagedObjectContextDidSaveNotification,
                                                    object: mainContext)
        return mainContext
    }()
     

    
     public func newDerivedContext() -> NSManagedObjectContext{
        var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.rootContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }
    
    // MARK: - Core Data Saving support
    public func saveContext(context: NSManagedObjectContext) {
         
        if context.parentContext === self.mainContext {
            saveDerivedContext(context)
            return
        }
        context.performBlock() {
            var error: NSError? = nil
            if !(context.obtainPermanentIDsForObjects(context.insertedObjects.allObjects, error: &error)) {
                NSLog("Error obtaining permanent IDs for \(context.insertedObjects.allObjects), \(error)")
            }
            
            if context.hasChanges && !context.save(&error) {
                NSLog("Unresolved core data error: \(error)")
                abort()
            }
        }
    }
    /*
    There are two forms of an object ID. When a managed object is first created, Core Data assigns it a temporary ID; only if it is saved to a persistent store does Core Data assign a managed object a permanent ID. You can readily discover whether an ID is temporary:
    */
     public func saveDerivedContext(context: NSManagedObjectContext ) {
        
        //
        context.performBlock() {
            var error: NSError? = nil
            if !(context.obtainPermanentIDsForObjects(context.insertedObjects.allObjects, error: &error)) {
                NSLog("Error obtaining permanent IDs for \(context.insertedObjects.allObjects), \(error)")
            }
            
            if context.hasChanges && !context.save(&error) {
                NSLog("Unresolved core data error: \(error)")
                abort()
            }
            
            self.saveContext(self.mainContext!)
        }
    }
    
    @objc func mainContextDidSave(notification: NSNotification) {
        self.saveContext(self.rootContext!)
    }
    
    
    
    /*
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    */
    
    
    

}
