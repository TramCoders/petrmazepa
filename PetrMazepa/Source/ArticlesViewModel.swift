//
//  ArticlesViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/13/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewModel: ViewModel {
   
    var loading = false {
        didSet {
            self.loadingStateChanged!(loading: self.loading)
        }
    }
    
    var articlesInserted: ((range: Range<Int>) -> Void)?
    var errorOccurred: ((error: NSError) -> Void)?
    var loadingStateChanged: ((loading: Bool) -> Void)?
    
    private let imageCache: ImageCache
    private let articlesFetcher: ArticlesFetcher
    private let articleSrorage: ArticleStorage
    
    required init(imageCache: ImageCache, articleStorage: ArticleStorage, articlesFetcher: ArticlesFetcher) {

        self.imageCache = imageCache
        self.articleSrorage = articleStorage
        self.articlesFetcher = articlesFetcher
    }
    
    var articlesCount: Int {
        get {
            return self.articleSrorage.allArticles().count
        }
    }
    
    func viewDidLoad() {
        
        guard self.loading == false else {
            return
        }
        
        guard self.articlesCount == 0 else {
            return
        }
        
        self.load()
    }
    
    func didScrollToBottom() {
        
        guard self.loading == false else {
            return
        }
        
        self.loadMore()
    }
    
    func requestThumb(index index: Int) -> UIImage? {
        
        let article = self.articleSrorage.allArticles()[index]
        let url = article.thumbUrl
        
        guard let notNilUrl = url else {
            return nil
        }
        
        var image: UIImage?
        
        self.imageCache.requestImage(url: notNilUrl) { imageData, error, fromCache in

            if fromCache {
                image = UIImage(data: imageData!)
                
            } else  {
                dispatch_async(dispatch_get_main_queue(), {
                    self.thumbImageLoaded!(index: index)
                })
            }
        }
        
        return image
    }
    
    private func loadMore() {
        
        let oldCount = self.articlesCount
        self.load(fromIndex: oldCount, count: 4)
    }
    
    private func load() {
        self.load(fromIndex: 0, count: 8)
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
