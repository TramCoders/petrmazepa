//
//  MOArticle.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/15/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation
import CoreData

private enum Keys: String {
    case DateAdded = "addedAt"
}

class MOArticle: ManagedObject {

    static func insertIntoContext(context: NSManagedObjectContext, article: Article) -> MOArticle {
        let moArticle: MOArticle = context.insertObject()
        moArticle.id = article.id
        moArticle.title = article.title
        moArticle.thumbPath = article.thumbPath
        moArticle.favourite = article.favourite
        moArticle.topOffset = article.topOffset
        moArticle.addedAt = NSDate()
        return moArticle
    }
}

extension MOArticle: ManagedObjectType {
    static var entityName: String {
        return "MOArticle"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor.init(key: Keys.DateAdded.rawValue , ascending: false)]
    }
}
