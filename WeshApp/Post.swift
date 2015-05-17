//
//  Post.swift
//  WeshApp
//
//  Created by rabzu on 10/05/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Post: NSManagedObject {

    @NSManaged var channelID: String
    @NSManaged var date: NSDate
    @NSManaged var post: String
    @NSManaged var author: AnyObject
    @NSManaged var location: String
    @NSManaged var channel: Channel
    @NSManaged var sender: Badge

}
