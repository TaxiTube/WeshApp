//
//  ChannelMngrTest.swift
//  WeshApp
//
//  Created by rabzu on 17/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//
/*
import XCTest
import WeshApp
import CoreData
import MultipeerConnectivity



class ChannelMngrTest: XCTestCase {

    
    
    var coreDataStack: CoreDataStack!
    var profileMngr: ProfileMngr!
    var channelMngr: ChannelMngr!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = TestCoreDataStack()
        channelMngr = ChannelMngr(managedObjectContext: coreDataStack.mainContext!,
                                         coreDataStack: coreDataStack)
        profileMngr = ProfileMngr(managedObjectContext: coreDataStack.mainContext!,
                                         coreDataStack: coreDataStack)
    }
    func testAddChannel(){
        
        let title = "Channel 1"
        let date = NSDate()
        
        
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        
        
        let author = profileMngr.addProfile("Zurab",
                                            lastName: "Kakabadze",
                                              peerID: testPeerID,
                                               photo: photoData)
        
        
        
        let channel = channelMngr.addChannel(title, desc:"", date: date, author: author!, photo: photoData )
        
        
        XCTAssertNotNil(channel,  "Camper should not be nil")
        XCTAssertTrue(channel?.title == title)
        XCTAssertTrue(channel?.date ==  date)
        XCTAssertTrue(channel?.author == author)
        XCTAssertTrue(channel?.author === author)
        XCTAssertTrue(channel?.photo.photo === photoData)

    }
    func testGetChannelByAuthor(){
        let title = "Channel 1"
        let date = NSDate()
        
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        
        
        let author = profileMngr.addProfile("Zurab",
            lastName: "Kakabadze",
            peerID: testPeerID,
            photo: photoData)
        
        
        
        channelMngr.addChannel(title, desc:"" ,date: date, author: author!, photo: photoData)
        
        let channel = channelMngr.getChannelByAuthor(author!)
        
        XCTAssertNotNil(channel, "A Channel should be returned")
    }
    
    func testRootContextIsSavedAfterAddingCamper() {
        
        //Create a text expectation linked to a notification
        let expectRoot =  self.expectationForNotification(NSManagedObjectContextDidSaveNotification,
                            object: coreDataStack.rootContext){
                notification in
                return true
        }
        
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        let author = profileMngr.addProfile("Zurab",
                                lastName: "Kakabadze",
                                  peerID: testPeerID,
                                   photo: photoData)
        channelMngr.addChannel("", desc:"",date: NSDate(), author: author!, photo: photoData)
        
        self.waitForExpectationsWithTimeout(2.0){
            error in
            XCTAssertNil(error, "Save did not Occur")
        }
        
    }

    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        channelMngr = nil
        coreDataStack = nil
    }



}
*/