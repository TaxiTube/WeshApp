//
//  SessionController.swift
//  WeshApp
//
//  Created by rabzu on 04/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData
import WeshAppLibrary

public class SessionMngr: NSObject, SessionContainerDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate{
    
    
    // MARK: MC connectivty Properties
    private var sessionContainer: SessionContainer!
    private var myPeerID: MCPeerID!
    private var advertiser:  MCNearbyServiceAdvertiser?
    private var  browser: MCNearbyServiceBrowser?
    //MARK: Persistance store and Core Data Properties
    private let coreDataStack: CoreDataStack!
    //private let myProfileMngr: ProfileMngr!
    private let badgeMngr: BadgeMngr!
    private let transcriptMngr: TranscriptMngr!
    private let channelMngr: ChannelMngr!
    
    //let profile: Profile?
    var myBadge: Badge?
    private let transcript: Transcript?
  
   
    
  
    //MARK: Initialisation
    override init(){
        super.init()
    }
    //On dealloc clean up the session by disconnecting from it.
    deinit {
        println("cleanup")
        advertiser!.stopAdvertisingPeer()
        sessionContainer.session.disconnect()
    }
    
   public init(coreDataStack: CoreDataStack){
    super.init()
  
        self.coreDataStack = coreDataStack
        //TODO: Lazy initialisation
        badgeMngr = BadgeMngr(managedObjectContext: coreDataStack.mainContext!,
                                         coreDataStack: coreDataStack)
        transcriptMngr = TranscriptMngr(managedObjectContext: coreDataStack.mainContext!,
                                               coreDataStack: coreDataStack)
        channelMngr = ChannelMngr(managedObjectContext: coreDataStack.mainContext!,
                                         coreDataStack: coreDataStack)
    }
    func setUpConnection(handle: String, totem: String = "") -> Bool{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let peerIDData = defaults.dataForKey("peerID"){
            myPeerID = NSKeyedUnarchiver.unarchiveObjectWithData(peerIDData) as MCPeerID
            sessionContainer = SessionContainer(myPeerID: myPeerID)
            myBadge = badgeMngr.getBadge(myPeerID)
            println("old PeerID \(myBadge!.peerID.displayName)")
        } else {
            myPeerID = MCPeerID(displayName: handle)
            //start a session
            sessionContainer = SessionContainer(myPeerID: myPeerID)
            //store peerID
            let Data = NSKeyedArchiver.archivedDataWithRootObject(self.myPeerID)
            defaults.setObject(Data, forKey: "peerID")
            defaults.synchronize()
            //To Do: Creating profile
            myBadge = badgeMngr.createBadge(handle, peerID: myPeerID, totem: totem)
            badgeMngr.save(coreDataStack.mainContext!)
            println("new peerID created \(myPeerID.displayName)" )
        }
        activatePeer()
        return true
    }
    
    private func activatePeer(){
        println("Im \(myPeerID.displayName)")
        sessionContainer.delegate =  self
        advertiser = startAdvertiser()
        advertiser!.delegate = self
        browser = startBrowsing()
        browser!.delegate = self
    }


  // MARK: SessionContainer delegate method implementations
    // Outgoing data
    func deviceConnected(newPeerID: MCPeerID){
       //1. Send my profile
       //2. send my channels
    
       //TODO: 
       //1.get handle from PeerID
       //2.save handle in a NSManagedobject
        
        
        
        
        
        
        /*
        //if profile!.channels.count > 0{
           
            var profileDict = profile!.toDictionary()
            profileDict.removeValueForKey("photo")
            profileDict.removeValueForKey("receivedMsg")
            profileDict.removeValueForKey("sentMsg")
           // profileDict.removeValueForKey("channel")
            

            let data = NSKeyedArchiver.archivedDataWithRootObject(profileDict)
            //println("data siza: \(data.length)")
            sessionContainer.multicastMsg(data)
        
        // }else{
        //       println("\(profile!.firstName) has no Channels")
      //  }

        */
    }
    
     func broadcastNewChannel(channel: Channel?){
        
        if let newChannel = channel{
            
            var channelDict = newChannel.toDictionary()
            //do not transmit author or transcirpts
            channelDict.removeValueForKey("author")
            channelDict.removeValueForKey("transcripts")
            //TODO:Image transmision must be imlimented
            //channelDict.removeValueForKey("photo")
            
            let data = NSKeyedArchiver.archivedDataWithRootObject(channelDict)
            //println("Channel data size: \(data.length)")
            sessionContainer.multicastMsg(data)
            
        }else{
            println("Channel Empty")
        }
     }
    func broadcastNewTranscript(transcriptMessage: Transcript?, receiverProfiles: [Profile]? = nil){
        if let receivers = receiverProfiles{
            // one receiver: privet message.
        }else{
            //wall post: Multicast
            if let transcript = transcriptMessage{
                var transcriptDict = transcript.toDictionary()
                transcriptDict.removeValueForKey("channel")
                transcriptDict.removeValueForKey("sender")
                transcriptDict.removeValueForKey("receivers")
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(transcriptDict)
                sessionContainer.multicastMsg(data)
            }
        }
    }
    func deleteProfile(peerID: MCPeerID){
        badgeMngr.deletePeer(peerID)
    }

    
    
    //Incoming
    func receivedData(#senderPeer: MCPeerID, data: NSData){
     /*
        let unserializedDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [String: AnyObject]
        
        //unserializedDict["channelID"]
        /*
        if let channel = channelMngr.getChannelByID(){
            
        } else {
        }
        */
        let object = NSManagedObject.fromDictionary(unserializedDict)(context:myBadge!.managedObjectContext!)
        
        switch object{
            case let profileObject as Profile:
            println("profile received \(profileObject.firstName)")
            case let channelObject as Channel:
                //get profile(using peerID) and insert the channel in its array
                //TODO: Perform fetchign on privateQ
                //If channel already exists do not update
                
                //println(channelObject.author.firstName)
                
                    if let senderProfile = myProfileMngr.getProfile(senderPeer){
                       // myProfileMngr.insertChannel(senderProfile, channel: channelObject)
                        channelMngr.insertProfile(channelObject, profile: senderProfile)
                    }else{
                        println("NO SUCH PROFILE DETECTED IN CORE DATA!")
                        
                    }
            
            case let transcriptObject as Transcript:
               let channel = channelMngr.getChannelByID(transcriptObject.channelID)
               if let c = channel {
                    //println("transcript for channel \(c.title) transcript message: \(transcriptObject.message)")
                    transcriptMngr.addTranscript(transcriptObject.message,
                        channel: channel,
                        date: transcriptObject.date,
                        sender: transcriptObject.sender,
                        receivers: transcriptObject.receivers.allObjects as? [Profile])
                    //TODO: Save context once channel is followed
                }else{
                    println("No channel found")
            }
            
            default: break
        }
        */
        //println(unserializedDictProfile.firstName)
    }
    
    // MARK: Browsing
    func startBrowsing(serviceType: String = "music")->MCNearbyServiceBrowser{
        
        let browser =  MCNearbyServiceBrowser(peer: myPeerID,
                                       serviceType: serviceType)
        browser.startBrowsingForPeers()
        println("\(myPeerID.displayName) is browsing")
        return browser
    }
    
    
    // MARK: Advertisment
    func startAdvertiser(serviceType: String = "music")->MCNearbyServiceAdvertiser{
        
        //var dict: Dictionary<String, String>?
        //if let channels:[Channel] = channelList?{
        //  dict = ["author":channels[0].author ,"channelName":channels[0].name]
        //}
        
        let advertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                          discoveryInfo: nil,
                                            serviceType: serviceType)
        advertiser.startAdvertisingPeer()
        
        println("\(myPeerID.displayName) advertising started")
        return advertiser
    }
    
    // MARK: Browsing delegate
    public func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!,  withDiscoveryInfo info: [NSObject : AnyObject]!){
        
        if let dict = info?{
            //println(dict["author"])
        }
        //in order to avoid simlutenaour invitaiton accepting
        if myPeerID.hash > peerID.hash {
            //Add discovred peer to a session
            browser.invitePeer(peerID, toSession: sessionContainer.session, withContext: nil, timeout: -1)
            println("peer \(myPeerID.displayName) invited to a session.")
        }
        
    }
    
   public func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!){
        println("peer \(peerID!.displayName) lost")
    }
    
    // MARK: Advertise delegate
    public func advertiser(MCNearbyServiceAdvertiser!,
        didReceiveInvitationFromPeer peerID: MCPeerID!,
                        withContext context: NSData!,
                          invitationHandler: ((Bool, MCSession!) -> Void)!){
            
            println("received invitation from:\(peerID!.displayName) ")
            let connectedPeers =  sessionContainer.session.connectedPeers as [MCPeerID]
            if !contains(connectedPeers, peerID!){
                invitationHandler(true, sessionContainer.session)
            }
    }
    
 
}
