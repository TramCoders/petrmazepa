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
    private var filteredArticles: [SimpleArticle]
    
    private let imageCache: ImageCache
    private let articleStorage: ArticleStorage
    private let articleDetailsPresenter: ArticleDetailsPresenter
    private let searchDismisser: SearchDismisser
    
    required init(imageCache: ImageCache, articleStorage: ArticleStorage, searchDismisser: SearchDismisser, articleDetailsPresenter: ArticleDetailsPresenter) {
        
        self.imageCache = imageCache
        self.articleStorage = articleStorage
        self.articleDetailsPresenter = articleDetailsPresenter
        self.searchDismisser = searchDismisser
        
        self.filteredArticles = articleStorage.allArticles()
    }
    
    func doneTapped() {
        self.searchDismisser.dismissSearch()
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
        
        var image: UIImage? = nil
        
        self.imageCache.requestImage(url: url, completion: { data, error, fromCache in
            
            if fromCache {

                image = UIImage(data: data!)
                return
            }
            
            if let index = self.findArticle(thumbUrl: url) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.thumbImageLoaded!(index: index)
                })
            }
        })
        
        return image
    }
    
    func requestArticle(index: Int) -> SimpleArticle {
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
