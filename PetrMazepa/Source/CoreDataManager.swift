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
    
    func createMainContext() -> NSManagedObjectContext {
    
        let bundles = [NSBundle(forClass: MOArticle.self)]
        guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("Managed Object Model is not found")
        }
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        context.undoManager = nil
        return context
    }

    private lazy var storeURL: NSURL = {
        return NSURL.documentsDirectoryURL.URLByAppendingPathComponent("PetrMazepa.pim")
    }()

    lazy var context: NSManagedObjectContext = {
        return self.createMainContext()
    }()

    func allArticlesCount() -> Int {
        return self.requestArticlesCount()
    }
    
    func allArticles() -> [Article] {
        return self.requestArticles()
    }
    
    func notFavoriteArticles() -> [Article] {
        return self.requestArticles(favorite: false)
    }
    
    func detailsFromArticle(article: Article) -> ArticleDetails? {

        guard let details = MOArticleDetails.findOrFetchInContext(context, matchingPredicate: NSPredicate(format: "self.article.id = %@", article.id)) else {
            return nil
        }
        return detailsFromManagedObject(details)
    }

    func saveArticles(articles: [Article]) -> [Article] {
        
        let existingArticles = self.allArticles()
        var savedArticles = [Article]()
        
        for article in articles {

            if let anArticle = self.find(article, inArticles: existingArticles) {
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

            if let anArticle = self.find(article, inArticles: existingArticles) {
                updatedArticles.append(anArticle)
            } else {
                updatedArticles.append(article)
            }
        }
        
        return updatedArticles
    }
    
    func saveArticle(article: Article) {
        MOArticle.insertIntoContext(self.context, article: article)
    }
    
    func saveArticleDetails(details: ArticleDetails, article: Article) {
        
        if let moArticle = self.managedObjectFromArticle(article) {
            
            let moDetails = self.saveArticleDetails(details)
            moArticle.details = moDetails
            moDetails.article = moArticle
        }
    }
    
    private func find(article: Article, inArticles articles: [Article]) -> Article? {
        
        for anArticle in articles {
            if anArticle.id == article.id {
                return anArticle
            }
        }
        
        return nil
    }
    
    func setTopOffset(article: Article, offset: Double) {
        self.managedObjectFromArticle(article)?.topOffset = offset
    }

    private func saveArticleDetails(details: ArticleDetails) -> MOArticleDetails {
        return MOArticleDetails.insertIntoContext(context, details: details)
    }
    
    private func managedObjectFromArticle(article: Article) -> MOArticle? {
        return MOArticle.findOrFetchInContext(context, matchingPredicate: NSPredicate(format: "id = %@", article.id))
    }
    
    private func articleFromManagedObject(moArticle: MOArticle) -> Article {
        return Article(id: moArticle.id, title: moArticle.title!, thumbPath: moArticle.thumbPath!, saved: moArticle.details != nil, favourite: moArticle.favourite!.boolValue, topOffset: moArticle.topOffset.doubleValue)
    }
    
    private func detailsFromManagedObject(moDetails: MOArticleDetails) -> ArticleDetails {
        return ArticleDetails(htmlText: moDetails.htmlText!)
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
        return self.requestManagedArticles(favorite: favorite).map({ self.articleFromManagedObject($0) })
    }

    private func requestManagedArticles(favorite favorite: Bool?) -> [MOArticle] {

        return MOArticle.fetchInContext(context) { fetchRequest in
            if let notNilFavorite = favorite {
                fetchRequest.predicate = NSPredicate(format: "favourite = %@", notNilFavorite)
            }
            fetchRequest.sortDescriptors = MOArticle.defaultSortDescriptors
        }
    }

    private func requestArticlesCount(favorite favorite: Bool? = nil) -> Int {
    
        return MOArticle.countInContext(context) { fetchRequest in
            if let notNilFavorite = favorite {
                fetchRequest.predicate = NSPredicate(format: "favourite = %@", notNilFavorite)
            }
        }
    }
}

public extension NSManagedObjectContext {

    func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {

        guard let object = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else {
            Tracker.trackException(withDescription: "Wrong object type")
            fatalError()
        }
        return object
    }

    func saveOrRollback() -> Bool {

        do {
            try save()
            return true
        } catch {
            Tracker.trackException(withDescription: "Failed to save changes in ctx")
            rollback()
            return false
        }
    }

    func performChanges(block: () -> ()) {
        performBlock { 
            block()
            self.saveOrRollback()
        }
    }
}
