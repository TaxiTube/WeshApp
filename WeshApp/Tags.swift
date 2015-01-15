//
//  Tags.swift
//  WeshApp
//
//  Created by Zuka on 1/13/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import CoreData

class Tags: NSManagedObject {

    @NSManaged var tag: String
    @NSManaged var channel: Channel

}
