//
//  Profile.swift
//  WeshApp
//
//  Created by Zuka on 1/16/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Profile: NSManagedObject {

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var peerID: AnyObject
    @NSManaged var badge: Badge
    @NSManaged var photo: ProfilePhoto

}
