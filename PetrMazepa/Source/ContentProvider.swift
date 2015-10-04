//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ContentProvider: ArticleStorage, ArticlesFetcher, ArticleDetailsFetcher {
    
    private var articles = [Article]()
    private let networking: Networking
    
    required init(networking: Networking) {
        self.networking = networking
    }
    
    func allArticles() -> [Article] {
        return self.articles
    }
    
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler) {

        self.networking.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            
            if let notNilArticles = articles {
                self.articles.appendContentsOf(notNilArticles)
            }
            
            completion(articles, error)
        }
    }
    
    func fetchArticleDetails(id id: String, completion: ArticleDetailsFetchHandler) {
        
        self.networking.fetchArticleDetails(id: id) { details, error in
            
            // TODO: cache article details
            completion(details, error)
        }
    }
}
