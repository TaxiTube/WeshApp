import Foundation
import CoreData


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
    
    func createPost(msg: String, channel: Channel?, date: NSDate, sender: Badge?)->Post?{
        
        let post =  NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post

        post.post = msg
        post.date = date

        if let s = sender { 
            post.sender = s
        }
        
        if let c = channel{
            post.channel = c
            post.channelID = c.channelID
        }
        return post
    }
    
    
    
    
}
