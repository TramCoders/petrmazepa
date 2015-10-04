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
    
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler) {
        
        self.networking.fetchArticleDetails(article: article) { details, error in
            
            if let notNilDetails = details {
            
                let updatedDetails = ArticleDetails(id: article.id, title: notNilDetails.title, author: article.author, thumbPath: article.thumbPath, htmlText: notNilDetails.htmlText, dateString: notNilDetails.dateString)
                completion(updatedDetails, error)

            } else {
                completion(details, error)
            }
        }
    }
}
