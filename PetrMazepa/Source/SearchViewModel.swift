//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel {
    
    var thumbImageLoaded: ((index: Int) -> Void)?
    var articlesChanged: (() -> Void)?
    
    private var query = ""
    private var filteredArticles: [Article]
    
    private let imageCache: ImageCache
    private let articleStorage: ArticleStorage
    private let articleDetailsPresenter: ArticleDetailsPresenter
    
    required init(imageCache: ImageCache, articleStorage: ArticleStorage, articleDetailsPresenter: ArticleDetailsPresenter) {
        
        self.imageCache = imageCache
        self.articleStorage = articleStorage
        self.articleDetailsPresenter = articleDetailsPresenter
        
        self.filteredArticles = articleStorage.allArticles()
    }
    
    func articleTapped(index index: Int) {
        
        let article = self.filteredArticles[index]
        self.articleDetailsPresenter.presentArticleDetails(article)
    }
    
    var articlesCount: Int {
        get {
            return self.filteredArticles.count
        }
    }
    
    func requestThumb(url url: NSURL?) -> UIImage? {
        
        guard let url = url else {
            return nil
        }
        
        var cachedImage: UIImage? = nil
        
        self.imageCache.requestImage(spec: ImageSpec(url: url, size: CGSizeMake(60, 60)), completion: { image, error, fromCache in
            
            if fromCache {

                cachedImage = image
                return
            }
            
            if let index = self.findArticle(thumbUrl: url) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.thumbImageLoaded!(index: index)
                })
            }
        })
        
        return cachedImage
    }
    
    func requestArticle(index: Int) -> Article {
        return self.filteredArticles[index]
    }
    
    func didChangeQuery(query: String) {

        self.query = query
        self.invalidateContent()
        self.articlesChanged!()
    }
    
    private func invalidateContent() {
        
        if self.query == "" {

            self.filteredArticles = self.articleStorage.allArticles()
            return
        }
        
        self.filteredArticles = self.articleStorage.allArticles().filter({ article in
            return article.title.containsString(self.query) || article.author.containsString(self.query)
        })
    }
    
    private func findArticle(thumbUrl url: NSURL) -> Int? {
        return self.filteredArticles.indexOf({ $0.thumbUrl == url })
    }
}
