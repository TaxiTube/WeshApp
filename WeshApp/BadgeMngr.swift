//
//  BadgeMngr.swift
//  WeshApp
//
//  Created by Zuka on 1/13/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData
import MultipeerConnectivity
import WeshAppLibrary


struct BadgeMngr {
    
    //MARK: Properties
    let managedObjectContext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    //MARK: Create Badge object in the managedObjectContext
    func createBadge(handle: String, peerID: MCPeerID, totem: String) -> Badge? {
            
            let badge = NSEntityDescription.insertNewObjectForEntityForName("Badge", inManagedObjectContext: self.managedObjectContext) as! Badge
            
            badge.handle  = handle
            badge.peerID = peerID
            badge.totem  = totem
        
            //coreDataStack.saveContext(self.managedObjectContext)
            return badge
    }
    
    func save(context: NSManagedObjectContext!){
        coreDataStack.saveContext(context)
    }
    
    func getBadge(peerID: MCPeerID) -> Badge?{
        
        //var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "Badge")
        fetchRequest.predicate = NSPredicate(format: "peerID == %@", peerID)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
            case let Result.Success(box):
                return box.unbox.first as! Badge?
            case let Result.Failure(error):
                println("Error getting profile. Error code: \(error.code)")
                return nil
        }
    }

    
    func getPeerChannels(peerID: MCPeerID) -> [Channel]?{
        
        
        let fetchRequest = NSFetchRequest(entityName: "Badge")
        fetchRequest.predicate = NSPredicate(format: "peerID == %@", peerID)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
            case let Result.Success(box):
                let badge = (box.unbox.first as! Badge?)
                return badge?.channels as! [Channel]?
            case let Result.Failure(error):
                println("Error getting profile. Error code: \(error.code)")
                return nil
        }
        
    }
    
    func deletePeer(peerID: MCPeerID){
        
         let fetchRequest = NSFetchRequest(entityName: "Badge")
        fetchRequest.predicate = NSPredicate(format: "peerID == %@", peerID)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
            case let Result.Success(box):
                let p = box.unbox.first as! Badge
                managedObjectContext.deleteObject(p)
                println("profile deleted \(p.peerID.displayName)")
            case let Result.Failure(error):
                println("Error getting profile. Error code: \(error.code)")
        }
        
    }

}