//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

class ContentProvider: ArticleStorage, FavouriteArticlesStorage, ArticlesFetcher, ArticleDetailsFetcher, FavouriteMaker, TopOffsetEditor, LastReadArticleMaker {
    
    private static let lastReadArticleKey = "LastReadArticle"
    
    private let networking: Networking
    private let coreData: CoreDataManager
    
    var lastReadArticle: Article?
    
    func setLastReadArticle(article: Article) {

        self.lastReadArticle = article
        
        NSUserDefaults.standardUserDefaults().setObject(article.id, forKey: ContentProvider.lastReadArticleKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    required init(networking: Networking, coreData: CoreDataManager) {

        self.networking = networking
        self.coreData = coreData
        self.setupLastReadArticle()
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
        self.coreData.context.performChanges({ self.coreData.makeFavourite(article: article, favourite: favourite) })
    }
    
    func setTopOffset(article: Article, offset: Double) {
        
        article.topOffset = offset
        self.coreData.context.performChanges({ self.coreData.setTopOffset(article, offset: offset) })
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {
        
        self.networking.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            
            if let notNilArticles = articles {
                
                let savedArticles = self.coreData.saveArticles(notNilArticles)
                self.coreData.context.saveOrRollback()
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
        
        if let details = self.coreData.detailsFromArticle(article) {
            
            completion(details, nil)
            return
        }
        
        guard allowRemote == true else {
            
            completion(nil, nil)
            return
        }
        
        self.networking.fetchArticleDetails(article: article) { details, error in
            
            if let notNilDetails = details {

                self.coreData.context.performChanges({ self.coreData.saveArticleDetails(notNilDetails, article: article) })
                article.saved = true                
                completion(notNilDetails, error)

            } else {
                completion(details, error)
            }
        }
    }
    
    private func setupLastReadArticle() {
        
        if let articleId = NSUserDefaults.standardUserDefaults().objectForKey(ContentProvider.lastReadArticleKey) as? String {
            
            for article in self.allArticles() {
                if article.id == articleId {
                    
                    self.lastReadArticle = article
                    break
                }
            }
        }
    }
}
