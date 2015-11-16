//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

class ContentProvider: ArticleStorage, FavouriteArticlesStorage, ArticlesFetcher, ArticleDetailsFetcher, FavouriteMaker {
    
    private var articles = [Article]()
    private let networking: Networking
    private let coreData = CoreDataManager()
    
    required init(networking: Networking) {
        self.networking = networking
    }
    
    func allArticles() -> [Article] {
        return self.articles
    }
    
    func favouriteArticles() -> [Article] {
        
        let request = NSFetchRequest(entityName: MOArticle.entityName)
        
        do {
            if let moArticles = try self.coreData.context.executeFetchRequest(request) as? [MOArticle] {
                return moArticles.map({ self.articleFromManagedObject($0) })
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    func makeFavourite(article article: Article, details: ArticleDetails, favourite: Bool) {

        article.favourite = favourite
        
        if favourite {
            
            // details
            let moDetails = NSEntityDescription.insertNewObjectForEntityForName(MOArticleDetails.entityName, inManagedObjectContext: self.coreData.context) as! MOArticleDetails

            moDetails.htmlText = details.htmlText
            moDetails.scrollTop = 0.0
            
            // article
            let moArticle = NSEntityDescription.insertNewObjectForEntityForName(MOArticle.entityName, inManagedObjectContext: self.coreData.context) as! MOArticle
            moArticle.id = article.id
            moArticle.title = article.title
            moArticle.thumbPath = article.thumbPath
            moArticle.favourite = article.favourite
            moArticle.details = moDetails

            moDetails.article = moArticle
            
        } else {
            
            let request = NSFetchRequest(entityName: MOArticle.entityName)
            request.predicate = NSPredicate(format: "id = %@", article.id)
            
            do {
                if let moArticle = try self.coreData.context.executeFetchRequest(request).last as? MOArticle {
                    self.coreData.context.deleteObject(moArticle)
                }
            } catch {
                // TODO:
            }
        }
        
        self.coreData.saveContext()
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {

        self.networking.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            
            if let notNilArticles = articles {
                self.articles.appendContentsOf(notNilArticles)
            }
            
            completion(articles, error)
        }
    }
    
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler) {
        
        self.networking.fetchArticleDetails(article: article) { details, error in
            
            if let notNilDetails = details {
                completion(notNilDetails, error)

            } else {
                completion(details, error)
            }
        }
    }
    
    private func articleFromManagedObject(moArticle: MOArticle) -> Article {
        
        return Article(id: moArticle.id!, title: moArticle.title!, thumbPath: moArticle.thumbPath!, favourite: moArticle.favourite!.boolValue)
    }
}
