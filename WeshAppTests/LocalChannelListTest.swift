//
//  LocalChannelListTest.swift
//  WeshApp
//
//  Created by rabzu on 02/12/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//
/*
import UIKit
import XCTest
import WeshApp
import CoreData
import MultipeerConnectivity


class LocalChannelListTest: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var profileMngr: ProfileMngr!
    var channelMngr: ChannelMngr!
    var transcriptMngr: TranscriptMngr!
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
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
    func createProfile()->Profile?{
        let testPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        let number = arc4random_uniform(150)
        
        
        return profileMngr.addProfile("Zurab \(number)",
            lastName: "Kakabadze \(number)",
            peerID: testPeerID,
            photo: photoData)
    }
    
    func createTranscript(channel: Channel?)(sender: Profile?)(receivers: [Profile])->Transcript?{
        let msg = "Test message \(arc4random_uniform(150))"
        let direction:  TranscriptDirection = .Send
        let date = NSDate()
        
        return transcriptMngr.addTranscript(msg,
            channel: channel,
            date: date,
            sender: sender,
            receivers: receivers)
    }

    func testLocalChannelVC(){
        
        
        
//        XCTAssertNotNil(vc.view, "View Did Not load")

        
        
    }
    
    

}
*/