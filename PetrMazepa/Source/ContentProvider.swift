//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ContentProvider: ArticleStorage, ArticlesFetcher {
    
    private var articles = [SimpleArticle]()
    private let networking: Networking
    
    required init(networking: Networking) {
        self.networking = networking
    }
    
    func allArticles() -> [SimpleArticle] {
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
}
