//
//  ObjCWrapperFunctions.swift
//  WeshApp
//
//  Created by rabzu on 06/12/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import Foundation
import CoreData

public class Box<T> {
    public let unbox: T
    init(_ value: T) { unbox = value }
}
public enum Result<T> {
    case Success(Box<T>)
    case Failure(NSError)
}

public func fetchRequestWrapper(context: NSManagedObjectContext)(fetchRequest: NSFetchRequest)->Result<[AnyObject]>{
    
    var maybeError: NSError?
    let maybeResults = context.executeFetchRequest(fetchRequest, error: &maybeError)

    
    if let results = maybeResults{
        return Result.Success(Box(results))
    }
    else if let error = maybeError {
        return Result.Failure(error)
    }else {
        assert(false, "The impossible occurred")
    }
}

