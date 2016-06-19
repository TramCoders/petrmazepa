//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit
import CoreData

class ContentProvider: ArticleStorage, FavouriteArticlesStorage, ArticlesFetcher, ArticleContentFetcher, FavouriteMaker, TopOffsetEditor, LastReadArticleMaker {
    
    private static let lastReadArticleKey = "LastReadArticle"
    
    private let networking: Networking
    private let coreData: CoreDataManager
    
    var lastReadArticle: ArticleCaption?
    
    func setLastReadArticle(article: ArticleCaption) {

        self.lastReadArticle = article
        
        NSUserDefaults.standardUserDefaults().setObject(article.id, forKey: ContentProvider.lastReadArticleKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    required init(networking: Networking, coreData: CoreDataManager) {

        self.networking = networking
        self.coreData = coreData
        self.setupLastReadArticle()
    }
    
    func allArticles() -> [ArticleCaption] {
        return self.coreData.allArticles()
    }
    
    func updateArticles(articles: [ArticleCaption]) -> [ArticleCaption] {
        return self.coreData.updateArticles(articles)
    }
    
    func allArticlesCount() -> Int {
        return self.coreData.allArticlesCount()
    }
    
    func favouriteArticles() -> [ArticleCaption] {
        return self.coreData.favouriteArticles()
    }
    
    func makeFavourite(article article: ArticleCaption, favourite: Bool) {

        var copiedArticle = article
        copiedArticle.favourite = favourite
        self.coreData.makeFavourite(article: copiedArticle, favourite: favourite)
        self.coreData.saveContext()
    }
    
    func setTopOffset(article: ArticleCaption, offset: Float) {

        var copiedArticle = article
        copiedArticle.topOffset = offset
        self.coreData.setTopOffset(copiedArticle, offset: offset)
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

    func fetchArticleContent(forCaption caption: ArticleCaption, completion: ArticleContentFetchHandler) {
        self.fetchArticleContent(forCaption: caption, allowRemote: true, completion: completion)
    }

    func fetchArticleContent(forCaption caption: ArticleCaption, allowRemote: Bool, completion: ArticleContentFetchHandler) {
        if let details = self.coreData.detailsFromArticles(caption) {

            completion(details, nil)
            return
        }

        guard allowRemote == true else {

            completion(nil, nil)
            return
        }

        self.networking.fetchArticleContent(forCaption: caption) { details, error in

            if let notNilDetails = details {

                var copiedAritcleCaption = caption
                self.coreData.saveArticleDetails(notNilDetails, article: copiedAritcleCaption)
                self.coreData.saveContext()
                copiedAritcleCaption.saved = true

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
