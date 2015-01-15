//
//  TestCoreDataStack.swift
//  WeshApp
//
//  Created by rabzu on 10/11/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import Foundation
import CoreData
import WeshApp
 

class TestCoreDataStack: CoreDataStack {
    
    override init(){
       
        super.init()
        
        self.persistentStoreCoordinator = {
            var psc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel:
                self.managedObjectModel)
            var error: NSError? = nil
            var ps = psc!.addPersistentStoreWithType( NSInMemoryStoreType,
                                                            configuration: nil,
                                                                      URL: nil,
                                                                  options: nil,
                                                                    error: &error)
            if (ps == nil){ abort() }
            return psc
        }()
    }

}
