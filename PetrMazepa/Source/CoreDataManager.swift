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
                print("Failed to save changes")
            }
        }
    }
    
    func allArticlesCount() -> Int {
        return self.requestArticlesCount(favorite: nil)
    }
    
    func allArticles() -> [ArticleCaption] {
        return self.requestArticles(favorite: nil)
    }
    
    func notFavoriteArticles() -> [ArticleCaption] {
        return self.requestArticles(favorite: false)
    }
    
    func favouriteArticles() -> [ArticleCaption] {
        return self.requestArticles(favorite: true)
    }
    
    func detailsFromArticles(article: ArticleCaption) -> ArticleContent? {
        
        let request = NSFetchRequest(entityName: MOArticleDetails.entityName)
        request.predicate = NSPredicate(format: "self.article.id = %@", article.id)
        
        do {
            if let moArticleDetails = try self.context.executeFetchRequest(request).last as? MOArticleDetails {
                return self.detailsFromManagedObject(moArticleDetails)
            }
        } catch {
            // TODO:
        }
        
        return nil
    }
    
    func makeFavourite(article article: ArticleCaption, favourite: Bool) {
        
        if let moArticle = self.managedObjectFromArticle(article) {
            moArticle.favourite = favourite
        } else {
            // TODO:
        }
    }
    
    func saveArticles(articles: [ArticleCaption]) -> [ArticleCaption] {
        
        let existingArticles = self.allArticles()
        var savedArticles = [ArticleCaption]()
        
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
    
    func updateArticles(articles: [ArticleCaption]) -> [ArticleCaption] {
        
        let existingArticles = self.allArticles()
        var updatedArticles = [ArticleCaption]()
        
        for article in articles {

            if let anArticle = self.find(article, inArticles: existingArticles) {
                updatedArticles.append(anArticle)
            } else {
                updatedArticles.append(article)
            }
        }
        
        return updatedArticles
    }
    
    func saveArticle(article: ArticleCaption) {
        
        let moArticle = NSEntityDescription.insertNewObjectForEntityForName(MOArticle.entityName, inManagedObjectContext: self.context) as! MOArticle
        moArticle.id = article.id
        moArticle.title = article.title
        moArticle.thumbPath = article.thumbPath
        moArticle.favourite = article.favourite
        moArticle.topOffset = article.topOffset
    }
    
    func saveArticleDetails(details: ArticleContent, article: ArticleCaption) {
        
        if let moArticle = self.managedObjectFromArticle(article) {
            
            let moDetails = saveArticleDetails(details)
            moArticle.details = moDetails
            moDetails.article = moArticle
        }
    }
    
    private func find(article: ArticleCaption, inArticles articles: [ArticleCaption]) -> ArticleCaption? {
        
        for anArticle in articles {
            if anArticle.id == article.id {
                return anArticle
            }
        }
        
        return nil
    }
    
    private func requestArticles(favorite favorite: Bool?) -> [ArticleCaption] {
        return self.requestManagedArticles(favorite: favorite).map({ self.articleFromManagedObject($0) })
    }
    
    private func requestManagedArticles(favorite favorite: Bool?) -> [MOArticle] {
        
        let request = NSFetchRequest(entityName: MOArticle.entityName)
        
        if let notNilFavorite = favorite {
            request.predicate = NSPredicate(format: "favourite = %@", notNilFavorite)
        }
        
        do {
            return try self.context.executeFetchRequest(request) as! [MOArticle]
        } catch {
            return []
        }
    }
    
    private func requestArticlesCount(favorite favorite: Bool?) -> Int {
        
        let request = NSFetchRequest(entityName: MOArticle.entityName)
        
        if let notNilFavorite = favorite {
            request.predicate = NSPredicate(format: "favourite = %@", notNilFavorite)
        }
        
        var error: NSError?
        return self.context.countForFetchRequest(request, error: &error)
    }
    
    private func saveArticleDetails(details: ArticleContent) -> MOArticleDetails {
        
        let moDetails = NSEntityDescription.insertNewObjectForEntityForName(MOArticleDetails.entityName, inManagedObjectContext: self.context) as! MOArticleDetails
        moDetails.htmlText = details.htmlText
        return moDetails
    }
    
    private func makeArticleFavourite(article article: ArticleCaption) {
        
        if let moArticle = self.managedObjectFromArticle(article) {
            moArticle.favourite = true
        } else {
            // TODO:
        }
    }
    
    private func makeArticleNotFavourite(article article: ArticleCaption) {
        
        if let moArticle = self.managedObjectFromArticle(article) {
            moArticle.favourite = false
        } else {
            // TODO:
        }
    }
    
    func setTopOffset(article: ArticleCaption, offset: Float) {
        
        if let moArticle = self.managedObjectFromArticle(article) {
            moArticle.topOffset = offset
        } else {
            // TODO:
        }
    }
    
    private func managedObjectFromArticle(article: ArticleCaption) -> MOArticle? {
        
        let request = NSFetchRequest(entityName: MOArticle.entityName)
        request.predicate = NSPredicate(format: "id = %@", article.id)
        
        do {
            return try self.context.executeFetchRequest(request).last as? MOArticle
        } catch {
            return nil
        }
    }
    
    private func articleFromManagedObject(moArticle: MOArticle) -> ArticleCaption {
        return ArticleCaption(id: moArticle.id!, title: moArticle.title!, thumbPath: moArticle.thumbPath!, saved: moArticle.details != nil, favourite: moArticle.favourite!.boolValue, topOffset: moArticle.topOffset!.floatValue)
    }
    
    private func detailsFromManagedObject(moDetails: MOArticleDetails) -> ArticleContent {
        return ArticleContent(htmlText: moDetails.htmlText!)
    }
}
