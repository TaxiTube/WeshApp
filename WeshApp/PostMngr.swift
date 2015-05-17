import Foundation
import CoreData
import MultipeerConnectivity


  struct PostMngr{
    
    let managedObjectContext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
   
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    func save(context: NSManagedObjectContext!){
        coreDataStack.saveContext(context)
    }
    
    func createPost(msg: String, channel: Channel?, date: NSDate, sender: Badge?, location: String? = nil , author: AnyObject )->Post?{
        
        let post =  NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post

        post.post = msg
        post.date = date
        post.author = author as! MCPeerID
        
        // sender can be nil
        if let s = sender { 
            post.sender = s
        }
        
        if let c = channel{
            post.channel = c
            post.channelID = c.channelID
        }
        
        if let l = location{
            post.location = l
        }
        
        return post
    }
    
    
    
    
}
