//
//  ProfileMngr.swift
//  WeshApp
//
//  Created by rabzu on 11/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import Foundation
import CoreData
import MultipeerConnectivity
import WeshAppLibrary
  
  struct ProfileMngr{
    
    //MARK: Properties
    let managedObjectContext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
     }
    func save(context: NSManagedObjectContext!){
        coreDataStack.saveContext(context)
    }
    
    //MARK: Insert and Upadate Operations
    func addProfile(firstName: String,
                     lastName: String,
                       peerID: MCPeerID,
                        photo: NSData) -> Profile? {
            
            let profile = NSEntityDescription.insertNewObjectForEntityForName("Profile",
                            inManagedObjectContext: self.managedObjectContext) as Profile

            let profilePhoto = NSEntityDescription.insertNewObjectForEntityForName("ProfilePhoto",
                                    inManagedObjectContext: self.managedObjectContext) as ProfilePhoto

            
                                
            profile.firstName = firstName
            profile.lastName = lastName
            profile.peerID = peerID
            
            //TODO: change photo to ? and use if let
            profile.photo = profilePhoto
            profilePhoto.photo = photo
         
                                
           //coreDataStack.saveContext(self.managedObjectContext)
            
           return profile
    }
  
    
    //MARK: Retrieve Operations
    func getProfile(peerID: MCPeerID) -> Profile?{
        
        //var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "Profile")
        fetchRequest.predicate = NSPredicate(format: "peerID == %@", peerID)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
            case let Result.Success(box):
                return box.unbox.first as Profile?
            case let Result.Failure(error):
                println("Error getting profile. Error code: \(error.code)")
                return nil
        }
    }
    func getOnlineProfiles(myProfile: Profile?) -> [Profile]?{
        let peerID = myProfile!.peerID as MCPeerID
        let fetchRequest = NSFetchRequest(entityName: "Profile")
        fetchRequest.predicate = NSPredicate(format: "peerID != %@", peerID)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
        case let Result.Success(box):
            return box.unbox as? [Profile]
        case let Result.Failure(error):
            println("Error getting profile. Error code: \(error.code)")
            return nil
        }
    }
    
    
    func deleteProfile(peerID: MCPeerID){
        
     
        let fetchRequest = NSFetchRequest(entityName: "Profile")
        fetchRequest.predicate = NSPredicate(format: "peerID == %@", peerID)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
        case let Result.Success(box):
            let p = box.unbox.first as Profile
             managedObjectContext.deleteObject(p)
            println("profile deleted \(p.peerID.displayName)")
        case let Result.Failure(error):
            println("Error getting profile. Error code: \(error.code)")
        }
        
    }

    //TO DO: Asyncrhonous Fetching
 /*
     public func getProfile(peerID: MCPeerID) -> Profile?{
        
      
        var error: NSError?
        var results: [AnyObject]?
        
        self.managedObjectContext.performBlock { () -> Void in
           
            let fetchRequest = NSFetchRequest(entityName: "Profile")
            fetchRequest.predicate = NSPredicate(format: "peerID == %@", peerID)
            
            let  results = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
           let p = results?.first as Profile
            
            println("count insdie \(p.firstName)")
        }
        println("count outside \(results?.first)")
        if results == nil  {
            println("ERROR: \(error)")
            return nil
        }
        
        
        return results!.first as Profile?
    }
  */

}