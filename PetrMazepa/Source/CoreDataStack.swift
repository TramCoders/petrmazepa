//
//  CoreDataStack.swift
//  PetrMazepa
//
//  Created by Roman Kopaliani on 7/7/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation
import CoreData

private let storeURL = NSURL.documentsDirectoryURL.URLByAppendingPathComponent("PetrMazepa.pim")

public func setUpMainContext() -> NSManagedObjectContext {
    
    let bundles = [NSBundle(forClass: MOArticle.self)]
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
        fatalError("Managed Object Model is not found")
    }
    
    let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
    
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = storeCoordinator
    context.undoManager = nil
    return context
}


public extension NSManagedObjectContext {
        
    func saveOrRollback() -> Bool {
        
        do {
            try save()
            return true
        } catch {
            Tracker.trackException(withDescription: "Failed to save changes in ctx")
            rollback()
            return false
        }
    }
    
    func performChanges(block: () -> ()) {
        
        performBlock {
            block()
            self.saveOrRollback()
        }
    }
}

public extension NSManagedObjectContext {

    var coordinator: NSPersistentStoreCoordinator {
        
        guard let coordinator = self.persistentStoreCoordinator else { fatalError("No PSC for context") }
        return coordinator
    }
    
    func createBackgroundContext() -> NSManagedObjectContext {
        
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
}