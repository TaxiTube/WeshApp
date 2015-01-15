//
//  Badge.swift
//  WeshApp
//
//  Created by Zuka on 1/13/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Badge: NSManagedObject {

    @NSManaged var handle: String
    @NSManaged var totem: String
    @NSManaged var peerID: AnyObject
    @NSManaged var profile: Profile
    @NSManaged var channels: NSSet

}
