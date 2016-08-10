//
//  MOArticle+CoreDataProperties.swift
//  PetrMazepa
//
//  Created by Roman Kopaliani on 7/7/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MOArticle {

    @NSManaged var addedAt: NSDate?
    @NSManaged var favourite: NSNumber?
    @NSManaged var id: String?
    @NSManaged var thumbPath: String?
    @NSManaged var title: String?
    @NSManaged var topOffset: NSNumber?
    @NSManaged var details: MOArticleDetails?

}
