//
//  ChannelMngr.swift
//  WeshApp
//
//  Created by rabzu on 16/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import Foundation
import CoreData
import MultipeerConnectivity
import WeshAppLibrary

  struct ChannelMngr{
    
    let managedObjectContext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
    
     init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    func save(context: NSManagedObjectContext!){
       coreDataStack.saveContext(context)
    }
    
    func createChannel(title: String, desc: String, date: NSDate, author: Badge) -> Channel? {
            
        let channel =  NSEntityDescription.insertNewObjectForEntityForName("Channel",
                            inManagedObjectContext: self.managedObjectContext) as Channel

        channel.title = title
        channel.desc = desc
        channel.date = date
        channel.author = author
        channel.channelID = NSUUID().UUIDString
       
        //TO DO: Add Tags
        return channel
    }

    func insertBadge(channel: Channel, badge: Badge)->Channel?{
        channel.author = badge
        return channel
    }
    func getChannelByAuthor(badge: Badge)->Channel?{
        
       
        let fetchRequest = NSFetchRequest(entityName: "Channel")
        fetchRequest.predicate = NSPredicate(format: "author == %@", badge)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
            case let Result.Success(box):
                return box.unbox.first as Channel?
            case let Result.Failure(error):
                println("Error getting profile. Error code: \(error.code)")
                return nil
        }
   
    }
    
    func getChannelByID(channelID: String)->Channel?{
        
        let fetchRequest = NSFetchRequest(entityName: "Channel")
        fetchRequest.predicate = NSPredicate(format: "channelID == %@", channelID)
        
        switch fetchRequestWrapper(managedObjectContext)(fetchRequest: fetchRequest){
        case let Result.Success(box):
            return box.unbox.first as Channel?
        case let Result.Failure(error):
            println("Error getting profile. Error code: \(error.code)")
            return nil
        }
    }
    
      func getAuthor(myPeerID: MCPeerID){
        
     }
    
}