//
//  Badge.swift
//  WeshApp
//
//  Created by Zuka on 1/16/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Badge: NSManagedObject {

    @NSManaged var handle: String
    @NSManaged var peerID: AnyObject
    @NSManaged var totem: String
    @NSManaged var channels: NSSet
    @NSManaged var profile: Profile
    @NSManaged var sentMsgs: NSSet

}
