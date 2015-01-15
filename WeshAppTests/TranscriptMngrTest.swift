//
//  TranscriptMngrTest.swift
//  WeshApp
//
//  Created by rabzu on 15/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//
/*
import XCTest
import WeshApp
import CoreData
import CoreData
import MultipeerConnectivity


class TranscriptMngrTest: XCTestCase {

    var coreDataStack: CoreDataStack!
    var transcriptMngr: TranscriptMngr!
    var profileMngr: ProfileMngr!
    var channelMngr: ChannelMngr!

    
    override func setUp() {

        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = TestCoreDataStack()
        transcriptMngr = TranscriptMngr(managedObjectContext: coreDataStack.mainContext!,
                                               coreDataStack: coreDataStack)
        profileMngr = ProfileMngr(managedObjectContext: coreDataStack.mainContext!,
            coreDataStack: coreDataStack)
        channelMngr = ChannelMngr(managedObjectContext: coreDataStack.mainContext!,
            coreDataStack: coreDataStack)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        profileMngr = nil
        channelMngr = nil
        transcriptMngr = nil
        coreDataStack = nil
        
    }
    func createProfile()->Profile?{
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        
      /*
        return profileMngr.addProfile("Zurab \(arc4random_uniform(150))",
            lastName: "Kakabadze \(arc4random_uniform(150))",
            peerID: testPeerID,
            photo: photoData)
        }
    */
    
    func createChannel(profile: Profile?)->Channel?{
        let title = "Channel \(arc4random_uniform(150))"
        let date = NSDate()
        
        return channelMngr.createChannel(title, desc: "desc1", date: date, author: badge! )
    }
    
    
    func testAddTranscript(){
        
        
        let msg = "Test message"
        let date = NSDate()
        let senderProfile = createProfile()
        let receiverProfile = createProfile()
        let channel = createChannel(senderProfile)
        let transcript = transcriptMngr.addTranscript(msg,
                                                        channel: channel,
                                                            date: date,
                                                         sender: senderProfile,
                                                      receivers:[receiverProfile!])
        
        
        XCTAssertNotNil(transcript,  "Camper should not be nil")
        XCTAssertTrue(transcript?.message == msg)
        XCTAssertTrue(transcript?.date == date)
        XCTAssertTrue(transcript?.channel == channel)
        XCTAssertTrue(transcript?.sender == senderProfile)
        XCTAssertTrue(transcript?.receivers.anyObject() as? Profile == receiverProfile)
        
        


        
        
    }
    func testRootContextIsSavedAfterAddingCamper() {
        
        //Create a text expectation linked to a notification
        let expectRoot =  self.expectationForNotification(NSManagedObjectContextDidSaveNotification,
                                object: coreDataStack.rootContext){
                notification in
                return true
        }
        let msg = "Test message"
        let date = NSDate()
        let senderProfile = createProfile()
        let receiverProfile = createProfile()
        let channel = createChannel(senderProfile)
        let transcript = transcriptMngr.addTranscript(msg,
            channel: channel,
            date: date,
            sender: senderProfile,
            receivers:[receiverProfile!])
        
        self.waitForExpectationsWithTimeout(2.0){
            error in
            XCTAssertNil(error, "Save did not Occur")
        }
        
    }

  

}
*/