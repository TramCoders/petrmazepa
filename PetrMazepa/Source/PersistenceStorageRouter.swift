//
//  PersistenceStorageRouter.swift
//  PetrMazepa
//
//  Created by Roman Kopaliani on 7/7/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

class PersistenceStorageRouter {
    
    func allArticlesCount() -> Int {
        return coreDataManager.requestArticlesCount()
    }
    
    
    
    private let coreDataManager: CoreDataManager
    
    init() {
        coreDataManager = CoreDataManager()
    }
}