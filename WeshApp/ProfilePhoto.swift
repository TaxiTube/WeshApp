//
//  ProfilePhoto.swift
//  WeshApp
//
//  Created by Zuka on 1/13/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class ProfilePhoto: NSManagedObject {

    @NSManaged var photo: NSData
    @NSManaged var profile: Profile

}
