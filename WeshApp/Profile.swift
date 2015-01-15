//
//  Profile.swift
//  WeshApp
//
//  Created by Zuka on 1/13/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Profile: NSManagedObject {

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var peerID: AnyObject
    @NSManaged var photo: ProfilePhoto
    @NSManaged var receivedMsg: Transcript
    @NSManaged var sentMsg: NSSet
    @NSManaged var badge: Badge

}
