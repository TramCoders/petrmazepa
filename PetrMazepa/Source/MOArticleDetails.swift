//
//  MOArticleDetails.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/15/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation
import CoreData

@objc(MOArticleDetails)
final class MOArticleDetails: ManagedObject {

// Insert code here to add functionality to your managed object subclass
    static func insertIntoContext(context: NSManagedObjectContext, details: ArticleDetails) -> MOArticleDetails {
    
        let moDetails: MOArticleDetails = context.insertObject()
        moDetails.htmlText = details.htmlText
        return moDetails
    }
}

extension MOArticleDetails: ManagedObjectType {
    static var entityName: String {
        return "MOArticleDetails"
    }
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}