//
//  Post.swift
//  WeshApp
//
//  Created by Zuka on 1/16/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Post: NSManagedObject {

    @NSManaged var channelID: String
    @NSManaged var date: NSDate
    @NSManaged var post: String
    @NSManaged var channel: Channel
    @NSManaged var sender: Badge

}
