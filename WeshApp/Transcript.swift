//
//  Transcript.swift
//  WeshApp
//
//  Created by Zuka on 1/13/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Transcript: NSManagedObject {

    @NSManaged var channelID: String
    @NSManaged var date: NSDate
    @NSManaged var message: String
    @NSManaged var channel: Channel
    @NSManaged var sender: Badge

}
