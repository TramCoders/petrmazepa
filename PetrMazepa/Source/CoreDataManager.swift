//
//  CoreDataManager.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/15/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager : FavouriteArticlesStorage, FavouriteMaker {
    
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
    
    func favouriteArticles() -> [Article] {
        
        let request = NSFetchRequest(entityName: MOArticle.entityName)
        
        do {
            if let moArticles = try self.context.executeFetchRequest(request) as? [MOArticle] {
                return moArticles.map({ self.articleFromManagedObject($0) })
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func makeFavourite(article article: Article, details: ArticleDetails, favourite: Bool) {
        
        if favourite {
            self.makeArticleFavourite(article: article, details: details)
        } else {
            self.makeArticleNotFavourite(article: article)
        }
    }
    
    private func makeArticleFavourite(article article: Article, details: ArticleDetails) {
        
        // details
        let moDetails = NSEntityDescription.insertNewObjectForEntityForName(MOArticleDetails.entityName, inManagedObjectContext: self.context) as! MOArticleDetails
        
        moDetails.htmlText = details.htmlText
        moDetails.scrollTop = 0.0
        
        // article
        let moArticle = NSEntityDescription.insertNewObjectForEntityForName(MOArticle.entityName, inManagedObjectContext: self.context) as! MOArticle
        moArticle.id = article.id
        moArticle.title = article.title
        moArticle.thumbPath = article.thumbPath
        moArticle.favourite = article.favourite
        moArticle.details = moDetails
        
        moDetails.article = moArticle
    }
    
    private func makeArticleNotFavourite(article article: Article) {
        
        let request = NSFetchRequest(entityName: MOArticle.entityName)
        request.predicate = NSPredicate(format: "id = %@", article.id)
        
        do {
            if let moArticle = try self.context.executeFetchRequest(request).last as? MOArticle {
                self.context.deleteObject(moArticle)
            }
        } catch {
            // TODO:
        }
    }
    
    private func articleFromManagedObject(moArticle: MOArticle) -> Article {
        return Article(id: moArticle.id!, title: moArticle.title!, thumbPath: moArticle.thumbPath!, favourite: moArticle.favourite!.boolValue)
    }
}
