//
//  NSManageObjectSerializationTest.swift
//  WeshApp
//
//  Created by rabzu on 28/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//
/*
import XCTest
import WeshApp
import CoreData
import MultipeerConnectivity


class NSManageObjectSerializationTest: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var profileMngr: ProfileMngr!
    var channelMngr: ChannelMngr!
    var transcriptMngr: TranscriptMngr!
    
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
    
    func createProfile(peerID: MCPeerID? = nil, id: UInt32? = nil)->Profile?{
       
        
        let testPeerID =  peerID ?? MCPeerID(displayName: UIDevice.currentDevice().name)
        
        let image = UIImage(named:"ChannelList.png")
        let photoData = UIImagePNGRepresentation(image)
        let number = id ?? arc4random_uniform(150)
        
        
        return profileMngr.addProfile("Zurab \(number)",
                                       lastName: "Kakabadze \(number)",
                                       peerID: testPeerID!,
                                       photo: photoData)
    }
    
    func createChannel(profile: Profile?)->Channel?{
        let title = "Channel \(arc4random_uniform(150))"
        
        let date = NSDate()
    
        return channelMngr.createChannel(title, desc: "desc1", date: date, author: p)
    }
    
    func createTranscript(channel: Channel?)(sender: Profile?)(receivers: [Profile])->Transcript?{
        let msg = "Test message \(arc4random_uniform(150))"
        let direction:  TranscriptDirection = .Send
        let date = NSDate()
        
        return transcriptMngr.createTranscript(msg,
                                         channel: channel,
                                            date: date,
                                          sender: sender,
                                       receivers: receivers)
    }
    
    func testProfileToDictionarySerialization(){
        let profile = createProfile()
        let profileDict  = profile!.toDictionary()
        let data = NSKeyedArchiver.archivedDataWithRootObject(profileDict)
        
        XCTAssertNotNil(profileDict,  "Camper should not be nil")
        XCTAssertNotNil(data,  "Camper should not be nil")

        XCTAssertTrue(profile!.firstName ==  profileDict["firstName"] as String)
        XCTAssertTrue(profile!.lastName ==  profileDict["lastName"] as String)
        XCTAssertTrue(profile!.peerID as MCPeerID ==  profileDict["peerID"] as MCPeerID)
        
        XCTAssertTrue(profile!.photo.photo ==  (profileDict["photo"] as [String: AnyObject])["photo"] as NSData)
        //TO DO: More test
    }
    func testDictionarySerialisation(){
        
        let profile = createProfile()
        let orginialDict = profile!.toDictionary()
        let data = NSKeyedArchiver.archivedDataWithRootObject(orginialDict)
        let unserializedDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [String: AnyObject]

         XCTAssertNotNil(unserializedDict,  "Camper should not be nil")
         XCTAssertTrue(orginialDict["firstName"]! as String ==  unserializedDict["firstName"] as String)
         XCTAssertTrue(orginialDict["lastName"]! as String ==  unserializedDict["lastName"] as String)
         XCTAssertTrue(orginialDict["peerID"]! as MCPeerID ==  unserializedDict["peerID"] as MCPeerID)
    }
    func testFromDictToProfile(){
        
        let profile = createProfile()
        createChannel(profile)
        createChannel(profile)
        createChannel(profile)
        createChannel(profile)
        createChannel(profile)
        
        let orginialDict = profile!.toDictionary()
        let data = NSKeyedArchiver.archivedDataWithRootObject(orginialDict)
        
       // println("size of data: \(data.length)")
        
        let unserializedDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [String: AnyObject]
        let unserializedDictProfile = NSManagedObject.fromDictionary(unserializedDict)(context:profile!.managedObjectContext!) as Profile
       
        println(unserializedDictProfile.channels.count)
        XCTAssertTrue(unserializedDictProfile.firstName  ==  profile!.firstName)
        XCTAssertTrue(unserializedDictProfile.lastName  ==  profile!.lastName)
        XCTAssertTrue(unserializedDictProfile.peerID as MCPeerID  ==  profile!.peerID as MCPeerID)
        
        XCTAssertTrue(unserializedDictProfile.photo.photo  ==  profile!.photo.photo)
        XCTAssertTrue(unserializedDictProfile.photo.profile.firstName == profile!.photo.profile.firstName)
      
    }
    func  testFromChannelToDict(){
        let profile = createProfile()
        var channel = createChannel(profile)
        
        var originalDict = channel!.toDictionary()
        println(originalDict)
    }
    func  testFromDictToChannel(){
        let profile = createProfile()
        var channel = createChannel(profile)
        
        var originalDict = channel!.toDictionary()
        originalDict.removeValueForKey("author")
        originalDict.removeValueForKey("transcripts")
        var newChannel = NSManagedObject.fromDictionary(originalDict)(context: channel!.managedObjectContext!) as Channel
        XCTAssertTrue(newChannel.title == channel!.title)
        println("test.....: \(newChannel.toDictionary())")
    }
}
*/