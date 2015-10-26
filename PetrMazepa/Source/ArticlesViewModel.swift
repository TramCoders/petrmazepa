//
//  ArticlesViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/13/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewModel {
   
    var loading = false {
        didSet {
            self.loadingStateChanged!(loading: self.loading)
        }
    }
    
    var thumbImageLoaded: ((index: Int) -> Void)?
    var articlesInserted: ((range: Range<Int>) -> Void)?
    var errorOccurred: ((error: NSError) -> Void)?
    var loadingStateChanged: ((loading: Bool) -> Void)?
    
    private let imageCache: ImageCache
    private let articlesFetcher: ArticlesFetcher
    private let articleSrorage: ArticleStorage
    private let searchPresenter: SearchPresenter
    private let articleDetailsPresenter: ArticleDetailsPresenter
    
    private var screenSize: CGSize?
    private var thumbSize: CGSize?
    private var screenArticlesAmount: Int = 0
    
    required init(imageCache: ImageCache, articleStorage: ArticleStorage, articlesFetcher: ArticlesFetcher, searchPresenter: SearchPresenter, articleDetailsPresenter: ArticleDetailsPresenter) {

        self.imageCache = imageCache
        self.articleSrorage = articleStorage
        self.articlesFetcher = articlesFetcher
        self.searchPresenter = searchPresenter
        self.articleDetailsPresenter = articleDetailsPresenter
    }
    
    var articlesCount: Int {
        get {
            return self.articleSrorage.allArticles().count
        }
    }
    
    func searchTapped() {
        self.searchPresenter.presentSearch()
    }
    
    func articleTapped(index index: Int) {
        
        let article = self.articleSrorage.allArticles()[index]
        self.articleDetailsPresenter.presentArticleDetails(article)
    }
    
    func viewDidLoad(screenSize size: CGSize) {

        // screen size
        self.screenSize = size
        
        // thumb size
        let thumbWidth = (size.width - 1) / 2
        self.thumbSize = CGSize.init(width: thumbWidth, height: thumbWidth)
        
        // check if articles have to be loaded
        guard self.loading == false else {
            return
        }
        
        guard self.articlesCount == 0 else {
            return
        }
        
        // load articles
        self.screenArticlesAmount = Int(ceil(size.height / (thumbWidth + 1))) * 2
        self.load(fromIndex: 0, count: self.screenArticlesAmount * 2)
    }
    
    func didChangeDistanceToBottom(distance: CGFloat) {
        
        guard self.loading == false else {
            return
        }
        
        guard let notNilScreenSize = self.screenSize else {
            return
        }
        
        if distance > notNilScreenSize.height * 2 {
            return
        }
        
        self.loadMore()
    }
    
    func requestArticleModel(index index: Int) -> (title: String, image: UIImage?) {
        
        let article = self.articleSrorage.allArticles()[index]
        let title = article.title
        let url = article.thumbUrl
        
        guard let notNilUrl = url else {
            return (title: title, image: nil)
        }
        
        guard let notNilThumbSize = self.thumbSize else {
            return (title: title, image: nil)
        }
        
        var cachedImage: UIImage?
        
        self.imageCache.requestImage(spec: ImageSpec(url: notNilUrl, size: notNilThumbSize)) { image, error, fromCache in

            if fromCache {
                cachedImage = image
                
            } else  {
                dispatch_async(dispatch_get_main_queue(), {
                    self.thumbImageLoaded!(index: index)
                })
            }
        }
        
        return (title: title, image: cachedImage)
    }
    
    private func loadMore() {
        
        let oldCount = self.articlesCount
        self.load(fromIndex: oldCount, count: self.screenArticlesAmount * 2)
    }
    
    private func load(fromIndex fromIndex: Int, count: Int) {
        
        self.loading = true
        
        self.articlesFetcher.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            dispatch_async(dispatch_get_main_queue(), {

                self.loading = false
                let newCount = self.articlesCount
                self.articlesInserted!(range: fromIndex..<newCount)
            })
        }
    }
}
