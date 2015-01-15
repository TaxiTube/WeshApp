//
//  ProfileMngr.swift
//  WeshApp
//
//  Created by rabzu on 11/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//
/*
import XCTest
import WeshApp
import CoreData
import MultipeerConnectivity

class ProfileMngrTest: XCTestCase {

    var coreDataStack: CoreDataStack!
    var profileMngr: ProfileMngr!
    var channelMngr: ChannelMngr!
    var transcriptMngr: TranscriptMngr!

    
    override func setUp() { 

        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = TestCoreDataStack()
        profileMngr = ProfileMngr(managedObjectContext: coreDataStack.mainContext!,
                                         coreDataStack: coreDataStack)
        channelMngr = ChannelMngr(managedObjectContext: coreDataStack.mainContext!,
                                         coreDataStack: coreDataStack)
        transcriptMngr = TranscriptMngr(managedObjectContext: coreDataStack.mainContext!,
                                               coreDataStack: coreDataStack)


    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        profileMngr = nil
        coreDataStack = nil
        channelMngr = nil
        transcriptMngr = nil
    }

    func testAddProfile(){
        
       
        
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        
        
        let profile = profileMngr.addProfile("Zurab",
                                    lastName: "Kakabadze",
                                      peerID: testPeerID,
                                       photo: photoData)
       
        /*
        
        let title = "Channel 1"
        let date = NSDate()
        let channel1 = channelMngr.addChannel(title,desc: "desc1" ,date: date, author: profile!, photo: nil)
        
        
        
        
        let channel2 = channelMngr.addChannel(title,desc: "desc2" ,date: date, author: profile!, photo: nil)
        

        XCTAssertNotNil(profile,  "Camper should not be nil")
        XCTAssertTrue(profile?.firstName == "Zurab")
        XCTAssertTrue(profile?.lastName ==  "Kakabadze")
        XCTAssertTrue(profile?.peerID as NSObject == testPeerID)
        XCTAssertTrue(profile?.photo.photo == photoData)
        let b = profile?.channels.containsObject(channel1!)
        XCTAssertTrue(b!.boolValue)
        let b1 = profile?.channels.containsObject(channel2!)
        XCTAssertTrue(b!.boolValue)
        
        */
  }
    
    func testRootContextIsSavedAfterAddingProfile() {
        
        //Create a text expectation linked to a notification
        let expectRoot =  self.expectationForNotification(NSManagedObjectContextDidSaveNotification,
                          object: coreDataStack.rootContext){
                            
                            notification in
                            return true
        }
        
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        
        let profile = profileMngr.addProfile("Zurab",
                                    lastName: "Kakabadze",
                                      peerID: testPeerID,
                                       photo: photoData)
        
        self.waitForExpectationsWithTimeout(2.0){
            error in
            XCTAssertNil(error, "Save did not Occur")
        }
        
    }
    
    func testGetNonExistantProfile() {

       let testPeerID = MCPeerID(displayName: "testName")
       let profile =  profileMngr.getProfile(testPeerID)
        
        XCTAssertNil(profile, "No Profile should be returned")
    }
    
    func testGetProfile() {
        
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        
         profileMngr.addProfile("Zurab",
            lastName: "Kakabadze",
            peerID: testPeerID,
            photo: photoData)
        
        let profile = profileMngr.getProfile(testPeerID)
        
        XCTAssertNotNil(profile, "A Profile should be returned")
    }
    func testGetProfileChannels(){
        /*
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"messi.png")
        let photoData = UIImagePNGRepresentation(image)
        
        profileMngr.addProfile("Zurab",
                                lastName: "Kakabadze",
                                peerID: testPeerID,
                                photo: photoData)
        
        let profile = profileMngr.getProfile(testPeerID)

        XCTAssertNotNil(profile, "A Profile should be returned")
    */
    }
 
    //Create peerID if one does not exist
    
    //else retrivew it from object graph model
    func trestPeerIDCreatRetreival(){
        
        let newPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        // check if peerID already exists
    }

}
*/