//
//  Channel.swift
//  WeshApp
//
//  Created by Zuka on 1/16/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Channel: NSManagedObject {

    @NSManaged var channelID: String
    @NSManaged var date: NSDate
    @NSManaged var desc: String
    @NSManaged var title: String
    @NSManaged var author: Badge
    @NSManaged var tags: NSSet
    @NSManaged var posts: NSSet

}
