//
//  SessionContainer.swift
//  WeshApp
//
//  Created by z.kakabadze on 30/10/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import Foundation
import MultipeerConnectivity

// Delegate protocol for updating UI when we receive data or resources from peers.
protocol SessionContainerDelegate{
    
    // Method used to signal to UI an initial message, incoming image resource has been received
    func receivedData(#senderPeer: MCPeerID, data: NSData)
    //Method used to signal when device is connected
    func deviceConnected(newPeerID: MCPeerID)
    //Method used to transmit incoming Transcrpts/messages
    func broadcastNewPost(postMessage: Post?, receiverProfiles: [Profile]?)
    //deletes a profile from NSManagedObjectContext
    func deleteProfile(profileID: MCPeerID)
    //func updatePost(post: Post)
}

 class SessionContainer:NSObject, MCSessionDelegate{
    
    let myPeerID: MCPeerID
    let session: MCSession
  
    var delegate: SessionContainerDelegate?
    
    init(myPeerID: MCPeerID){
        
        self.myPeerID = myPeerID
        session = MCSession(peer: myPeerID)
        super.init()
        session.delegate = self
    }
   

        
    // Helper method for human readable printing of MCSessionState.  This state is per peer.
    func multicastMsg(data: NSData)->Bool{
        
        if(session.connectedPeers.count != 0){
            var error : NSError?
            session.sendData(data,
                toPeers: session.connectedPeers,
                withMode: .Unreliable,
                error: &error)
            if error != nil {
                print("Error sending data: \(error?.localizedDescription)")
                return false
            }
            return true
        }else{
            return false
        }
       
    }
    
   
   
    // MARK: Session Delegate
    // Override this method to handle changes to peer session state
     func session(MCSession!,  peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        var status: String!
        switch state {
            case MCSessionState.NotConnected:
                status = "disconnected"
            case MCSessionState.Connecting:
                status = "connecting"
            case MCSessionState.Connected:
                status = "connected"
        }
        let adminMsg = "\(myPeerID.displayName) is \(status) \(peerID.displayName)"
        println("Admin Message: \(adminMsg)")
       
        
        // Notify the delegate that we have received a new chunk of data from a peer
        
        if status == "connected"{
            self.delegate!.deviceConnected(peerID)
        }else if status == "disconnected"{
            delegate!.deleteProfile(peerID)
        }
        
    }
    
    // MCSession Delegate callback when receiving data from a peer in a given session
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {

        dispatch_async(dispatch_get_main_queue()) {
            self.delegate!.receivedData(senderPeer: peerID, data: data)
        }
    }
    
    func session(
        session: MCSession!,
        didStartReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        withProgress progress: NSProgress!){
            
    }
    func session(                               session: MCSession!,
        didFinishReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!,
        withError error: NSError!) {
    }
   func session(
        session: MCSession!,
        didReceiveStream stream: NSInputStream!,
        withName streamName: String!,
        fromPeer peerID: MCPeerID!) {
            
    }

    
    
}