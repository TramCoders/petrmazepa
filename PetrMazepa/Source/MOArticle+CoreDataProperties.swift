//
//  MOArticle+CoreDataProperties.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/15/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MOArticle {

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var thumbPath: String?
    @NSManaged var favourite: NSNumber?
    @NSManaged var details: MOArticleDetails?
    @NSManaged var topOffset: NSNumber?
}
