//
//  SessionMngrTest.swift
//  WeshApp
//
//  Created by rabzu on 24/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//
/*
import UIKit
import XCTest
import WeshApp
import CoreData
import MultipeerConnectivity

class SessionMngrTest:  NSManageObjectSerializationTest {
    
    var sessionMngr: SessionMngr!
    
    override func setUp() {
        super.setUp()
       sessionMngr = SessionMngr(coreDataStack: coreDataStack)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        coreDataStack = nil
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("peerID")
    }
    
    
    
    func testDeviceConnected(){
        let channelMngr = ChannelMngr(managedObjectContext: coreDataStack.mainContext!,
            coreDataStack: coreDataStack)
        
        /*
        let title = "Channel 1"
        let date = NSDate()
        
        
        let channel = channelMngr.addChannel(title, date: date, author: sessionMngr.profile! )
        */
        
    
        sessionMngr.deviceConnected()
    }
    func testBroadcastNewChannel(){
        let channelMngr = ChannelMngr(managedObjectContext: coreDataStack.mainContext!,
                                             coreDataStack: coreDataStack)
     
        let title = "Channel 1"
        let date = NSDate()
        
        
        let channel = channelMngr.addChannel(title, desc: "" ,date: date, author: sessionMngr.profile!, photo: nil )
        //NSManagedObjectContext.
        //sessionMngr.broadcastNewChannel(channel)
        
    }
    func testReceivedData(){
        
        let myProfile = createProfile(id: 1)
        let receiverPeerID = MCPeerID(displayName: "Receiver")
        let receiverProfile = createProfile(peerID:receiverPeerID, id: 2)
        
        createChannel(myProfile)
        createChannel(myProfile)
        
        let receivedChannel = createChannel(receiverProfile) as Channel?
        let orginialDict = receivedChannel!.toDictionary()
        coreDataStack.mainContext!.deleteObject(receivedChannel!)
        let data = NSKeyedArchiver.archivedDataWithRootObject(orginialDict)

        sessionMngr.receivedData(senderPeer: receiverPeerID, data: data)
    }
        


}
*/