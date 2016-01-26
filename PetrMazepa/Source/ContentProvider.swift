//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

class ContentProvider: ArticleStorage, FavouriteArticlesStorage, ArticlesFetcher, ArticleDetailsFetcher, FavouriteMaker, TopOffsetEditor, ArticleCleaner {
    
    private let networking: Networking
    private let coreData: CoreDataManager
    
    var lastReadArticle: Article? {
        
        get {
            return self.allArticles().first     // TODO: get a real last read article
        }

        set(article) {
            // TODO: store a last read article id in the user defaults
        }
    }
    
    required init(networking: Networking, coreData: CoreDataManager) {

        self.networking = networking
        self.coreData = coreData
    }
    
    func allArticles() -> [Article] {
        return self.coreData.allArticles()
    }
    
    func updateArticles(articles: [Article]) -> [Article] {
        return self.coreData.updateArticles(articles)
    }
    
    func allArticlesCount() -> Int {
        return self.coreData.allArticlesCount()
    }
    
    func favouriteArticles() -> [Article] {
        return self.coreData.favouriteArticles()
    }
    
    func makeFavourite(article article: Article, favourite: Bool) {

        article.favourite = favourite
        self.coreData.makeFavourite(article: article, favourite: favourite)
        self.coreData.saveContext()
    }
    
    func setTopOffset(article: Article, offset: Float) {
        
        article.topOffset = offset
        self.coreData.setTopOffset(article, offset: offset)
        self.coreData.saveContext()
    }
    
    func clearCache() {
        
        self.coreData.deleteAllArticles()
        self.coreData.saveContext()
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {
        
        self.networking.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            
            if let notNilArticles = articles {
                
                let savedArticles = self.coreData.saveArticles(notNilArticles)
                self.coreData.saveContext()
                completion(articles: savedArticles, error: error)
                
            } else {
                completion(articles: [], error: error)
            }
        }
    }
    
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler) {
        self.fetchArticleDetails(article: article, allowRemote: true, completion: completion)
    }
    
    func fetchArticleDetails(article article: Article, allowRemote: Bool, completion: ArticleDetailsFetchHandler) {
        
        if let details = self.coreData.detailsFromArticles(article) {
            
            completion(details, nil)
            return
        }
        
        guard allowRemote == true else {
            
            completion(nil, nil)
            return
        }
        
        self.networking.fetchArticleDetails(article: article) { details, error in
            
            if let notNilDetails = details {
                
                self.coreData.saveArticleDetails(notNilDetails, article: article)
                self.coreData.saveContext()
                article.saved = true
                
                completion(notNilDetails, error)

            } else {
                completion(details, error)
            }
        }
    }
}
