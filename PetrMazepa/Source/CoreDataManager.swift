//
//  CoreDataManager.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/15/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

protocol ManagedObjectConvertable {
    associatedtype ManagedObjectType
    init(_: ManagedObjectType)
}

//class PersistenceLayer {
//    
//    let mainContext: NSManagedObjectContext
//    
//    init() {
//        mainContext = setUpMainContext()
//    }
//    
//    
//}
//
//private extension PersistenceLayer {
//    
//    private func requestManagedArticles(favorite favorite: Bool?) -> [MOArticle] {
//        
//        return MOArticle.fetchInContext(mainContext) { fetchRequest in
//            if let notNilFavorite = favorite {
//                fetchRequest.predicate = MOArticle.predicate(forFavourites: notNilFavorite)
//            }
//            fetchRequest.sortDescriptors = MOArticle.defaultSortDescriptors
//        }
//    }
//}

class CoreDataManager {

    lazy var mainContext: NSManagedObjectContext = {
        return setUpMainContext()
    }()
    
    func allArticles() -> [Article] {
        return self.requestArticles()
    }
    
    func notFavoriteArticles() -> [Article] {
        return self.requestArticles(favorite: false)
    }
    
    func detailsFromArticle(article: Article) -> ArticleDetails? {
        guard let details = managedObjectFromArticle(article)?.details else {
            return nil
        }
        return ArticleDetails(details)
    }

    func saveArticles(articles: [Article]) -> [Article] {
        
        let existingArticles = self.allArticles()
        var savedArticles = [Article]()
        
        for article in articles {

            
            if let anArticle = existingArticles.findElement({ $0 == article }) {
                savedArticles.append(anArticle)

            } else {
                
                self.saveArticle(article)
                savedArticles.append(article)
            }
        }
        
        return savedArticles
    }
    
    func updateArticles(articles: [Article]) -> [Article] {
        let existingArticles = self.allArticles()
        var updatedArticles = [Article]()
        
        for article in articles {

            if let anArticle = existingArticles.findElement({ $0 == article }) {
                updatedArticles.append(anArticle)
            } else {
                updatedArticles.append(article)
            }
        }
        
        return updatedArticles
    }
    
    func saveArticle(article: Article) {
        MOArticle.insertIntoContext(self.mainContext, article: article)
    }
    
    func saveArticleDetails(details: ArticleDetails, article: Article) {
        
        if let moArticle = self.managedObjectFromArticle(article) {
            
            let moDetails = self.saveArticleDetails(details)
            moArticle.details = moDetails
            moDetails.article = moArticle
        }
    }
    
    func setTopOffset(article: Article, offset: Double) {
        self.managedObjectFromArticle(article)?.topOffset = offset
    }

    private func saveArticleDetails(details: ArticleDetails) -> MOArticleDetails {
        return MOArticleDetails.insertIntoContext(mainContext, details: details)
    }
    
    private func managedObjectFromArticle(article: Article) -> MOArticle? {
        return MOArticle.findOrFetchInContext(mainContext, matchingPredicate: MOArticle.predicate(byId: article.id))
    }
    
    func requestArticlesCount(favorite favorite: Bool? = nil) -> Int {
        
        return MOArticle.countInContext(mainContext) { fetchRequest in
            if let notNilFavorite = favorite {
                fetchRequest.predicate = MOArticle.predicate(forFavourites: notNilFavorite)
            }
        }
    }
}

//MARK: FavouriteArticlesStorage
extension CoreDataManager: FavouriteArticlesStorage {

    func favouriteArticles() -> [Article] {
        return self.requestArticles(favorite: true)
    }
}

//MARK: FavouriteMaker
extension CoreDataManager: FavouriteMaker {

    func makeFavourite(article article: Article, favourite: Bool) {
        self.managedObjectFromArticle(article)?.favourite = favourite
    }
}

//MARK: Fetching
private extension CoreDataManager {

    private func requestArticles(favorite favorite: Bool? = nil) -> [Article] {
        return self.requestManagedArticles(favorite: favorite).map({ Article($0) })
    }

    private func requestManagedArticles(favorite favorite: Bool?) -> [MOArticle] {

        return MOArticle.fetchInContext(mainContext) { fetchRequest in
            if let notNilFavorite = favorite {
                fetchRequest.predicate = MOArticle.predicate(forFavourites: notNilFavorite)
            }
            fetchRequest.sortDescriptors = MOArticle.defaultSortDescriptors
        }
    }
}
