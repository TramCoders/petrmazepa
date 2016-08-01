//
//  ManagedObjectType.swift
//  PetrMazepa
//
//  Created by Roman Kopaliani on 6/9/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation
import CoreData

public class ManagedObject: NSManagedObject {}

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

public extension ManagedObjectType where Self: ManagedObject {

    static func populatedObjectInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.fault {
            guard let result = object as? Self where predicate.evaluateWithObject(object) else { continue }
            return result
        }
        return nil
    }

    static func findOrCreateInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: Self -> ()) -> Self {
        guard let object = findOrFetchInContext(context, matchingPredicate: predicate) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }

    static func findOrFetchInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let object = populatedObjectInContext(context, matchingPredicate: predicate) else {
            return fetchInContext(context) { fetchRequest in
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.fetchLimit = 1
            }.first
        }
        return object
    }

    static func countInContext(context: NSManagedObjectContext, @noescape requestConfiguration configuration: NSFetchRequest -> () = {_ in}) -> Int {
        let request = NSFetchRequest(entityName: Self.entityName)
        configuration(request)
        var error: NSError?
        let result = context.countForFetchRequest(request, error:&error)
        if result == NSNotFound {
//            Tracker.trackException(withDescription: "Failed to execute count request, error:\(error)")    // FIXME: must be tracked
            fatalError()
        }
        return result
    }

    static func fetchInContext(context: NSManagedObjectContext, @noescape requestConfiguration configuration: NSFetchRequest -> () = {_ in}) -> [Self] {
        let request = NSFetchRequest(entityName: Self.entityName)
        configuration(request)
        guard let result = try! context.executeFetchRequest(request) as? [Self] else {
//            Tracker.trackException(withDescription: "Wrong entity type fetched")    // FIXME: must be tracked
            fatalError()
        }
        return result
    }
}

extension CollectionType where Generator.Element: ManagedObject {
    
    public func fetchFaultedObjects() {
        guard
            self.isEmpty == false else { return }
        
        guard
            let context = self.first?.managedObjectContext else { fatalError("Managed Object must have context. Should not happen like ever") }
        
        let faults = self.filter({ $0.fault })
        
        guard
            let firstMO = faults.first else { return }
        
        let request = NSFetchRequest()
        request.entity = firstMO.entity
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "self in %", faults)
        try! context.executeRequest(request)
    }
}

public extension NSManagedObjectContext {
    
    func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {
        
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else {
//            Tracker.trackException(withDescription: "Wrong object type")
            fatalError()
        }
        return object
    }
}