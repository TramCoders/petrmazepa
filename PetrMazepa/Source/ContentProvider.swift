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
        return self.coreData.favouriteArticles()
    }
    
    func makeFavourite(article article: Article, details: ArticleDetails, favourite: Bool) {

        article.favourite = favourite
        self.coreData.makeFavourite(article: article, details: details, favourite: favourite)
        self.coreData.saveContext()
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {
        self.fetchArticles(fromIndex: fromIndex, count: count, allowRemote: true, completion: completion)
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, allowRemote: Bool, completion: ArticlesFetchHandler) {
        
        guard allowRemote == true else {
            
            completion(nil, nil)
            return
        }
        
        self.networking.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            
            if let notNilArticles = articles {
                self.articles.appendContentsOf(notNilArticles)
            }
            
            completion(articles, error)
        }
    }
    
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler) {
        self.fetchArticleDetails(article: article, allowRemote: true, completion: completion)
    }
    
    func fetchArticleDetails(article article: Article, allowRemote: Bool, completion: ArticleDetailsFetchHandler) {
        
        if let details = self.coreData.favouriteArticleDetails(article: article) {
            
            completion(details, nil)
            return
        }
        
        guard allowRemote == false else {
            
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
