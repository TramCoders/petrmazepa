//
//  CoreDataManager.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/15/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private lazy var documentsPath: NSURL = {
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last!
    }()
    
    private lazy var model: NSManagedObjectModel = {

        let modelUrl = NSBundle.mainBundle().URLForResource("PetrMazepa", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelUrl)!
    }()
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        let url = self.documentsPath.URLByAppendingPathComponent("PetrMazepa")
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            abort()
        }
        
        return coordinator
    }()
    
    lazy var context: NSManagedObjectContext = {

        let coordinator = self.coordinator
        var context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    func saveContext() {
        
        if self.context.hasChanges {
            
            do {
                try self.context.save()
            } catch {
                abort()
            }
        }
    }
}
