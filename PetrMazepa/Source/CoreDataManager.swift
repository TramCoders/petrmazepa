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
    
    private lazy var managedObjectModel: NSManagedObjectModel = {

        let modelUrl = NSBundle.mainBundle().URLForResource("PetrMazepa", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelUrl)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.documentsPath.URLByAppendingPathComponent("PetrMazepa")
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {

        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
}
