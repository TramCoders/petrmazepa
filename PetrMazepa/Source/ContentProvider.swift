//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

class ContentProvider: ArticleStorage, FavouriteArticlesStorage, ArticlesFetcher, ArticleDetailsFetcher, FavouriteMaker, TopOffsetEditor {
    
    private let networking: Networking
    private let coreData = CoreDataManager()
    
    required init(networking: Networking) {
        self.networking = networking
    }
    
    func allArticles() -> [Article] {
        return self.coreData.allArticles()
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
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {
        self.fetchArticles(fromIndex: fromIndex, count: count, allowRemote: true, completion: completion)
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, allowRemote: Bool, completion: ArticlesFetchHandler) {
        
        if (fromIndex == 0) && (self.coreData.allArticlesCount() > 0) {
            completion(articles: self.coreData.allArticles(), error: nil)
            return
        }
        
        guard allowRemote == true else {
            
            completion(articles: nil, error: nil)
            return
        }
        
        self.networking.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            
            if let notNilArticles = articles {
                self.coreData.saveArticles(notNilArticles)
            }
            
            completion(articles: articles, error: error)
        }
    }
    
    func cleanInMemoryCache() {
        self.coreData.removeAll()
    }
    
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler) {
        self.fetchArticleDetails(article: article, allowRemote: true, completion: completion)
    }
    
    func fetchArticleDetails(article article: Article, allowRemote: Bool, completion: ArticleDetailsFetchHandler) {
        
        if let details = self.coreData.favouriteArticleDetails(article: article) {
            
            completion(details, nil)
            return
        }
        
        guard allowRemote == true else {
            
            completion(nil, nil)
            return
        }
        
        self.networking.fetchArticleDetails(article: article) { details, error in
            
            if let notNilDetails = details {
                completion(notNilDetails, error)

            } else {
                completion(details, error)
            }
        }
    }
}
