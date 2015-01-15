import Foundation
import CoreData


  struct TranscriptMngr{
    
    let managedObjectContext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
   
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    func save(context: NSManagedObjectContext!){
        coreDataStack.saveContext(context)
    }
    
    func createTranscript(msg: String, channel: Channel?, date: NSDate, sender: Badge?)->Transcript?{
        
        let transcript =  NSEntityDescription.insertNewObjectForEntityForName("Transcript", inManagedObjectContext: self.managedObjectContext) as Transcript

        transcript.message = msg
        transcript.date = date

        if let s = sender {
            transcript.sender = s
        }
        
        if let c = channel{
            transcript.channel = c
            transcript.channelID = c.channelID
        }
        return transcript
    }
    
    
    
    
}
