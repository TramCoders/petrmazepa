//
//  ArticlesViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/13/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewModel : ViewModel {
    
    var articlesInserted: ((range: Range<Int>) -> Void)?
    var allArticlesDeleted: (() -> Void)?
    var articlesUpdated: ((newCount: Int) -> Void)?
    var loadingInOfflineModeFailed: (() -> Void)?
    var errorOccurred: (() -> Void)?
    var refreshingStateChanged: ((refreshing: Bool) -> Void)?
    var loadingMoreStateChanged: ((loadingMore: Bool) -> Void)?
    var noArticlesVisibleChanged: ((visible: Bool) -> Void)?
    var lastReadArticleVisibleChanged: ((visible: Bool, animated: Bool) -> Void)?
    var navigationBarVisibleChanged: ((visible: Bool, animated: Bool) -> Void)?
    
    private let settings: ReadOnlySettings
    private let imageGateway: ImageGateway
    private let articlesFetcher: ArticlesFetcher
    private let articleStorage: ArticleStorage
    private let router: RouterNavigation
    
    private var fetchedArticles = [Article]()
    
    private var screenSize: CGSize?
    private var thumbSize: CGSize?
    private var screenArticlesAmount: Int = 0
    private var loadingInOfflineModeHasShown = false
    private var errorOccurredHasShown = false
    private var startOffset: CGFloat!
    
    private var lastReadArticleExists: Bool {
        return self.lastReadArticle == nil ? false : true
    }
    
    private var lastReadArticle: Article? {
        return self.articleStorage.lastReadArticle
    }
    
    var lastReadArticleViewModel: SimpleArticleCellModel? {
        
        guard let article = self.lastReadArticle else {
            return nil
        }
        
        return SimpleArticleCellModel(settings: self.settings, article: article, imageGateway: self.imageGateway)
    }
    
    var articlesCount: Int {
        
        if self.fetchedArticles.count > 0 {
            return self.fetchedArticles.count
        } else {
            return self.articleStorage.allArticlesCount()
        }
    }
    
    var refreshing: Bool = false {
        didSet {
            
            guard self.viewIsPresented else {
                return
            }
            
            self.refreshingStateChanged!(refreshing: self.refreshing)
        }
    }
    
    var loadingMore: Bool = false {
        didSet {
            
            guard self.viewIsPresented else {
                return
            }
            
            self.loadingMoreStateChanged!(loadingMore: self.loadingMore)
        }
    }
    
    private var loading: Bool {
        return self.refreshing || self.loadingMore
    }
    
    var lastReadArticleVisible: Bool = true
    var navigationBarVisible: Bool = true
    
    required init(settings: ReadOnlySettings, articleStorage: ArticleStorage, imageGateway: ImageGateway, articlesFetcher: ArticlesFetcher, router: RouterNavigation) {

        self.settings = settings
        self.articleStorage = articleStorage
        self.imageGateway = imageGateway
        self.articlesFetcher = articlesFetcher
        self.router = router
    }
    
    func articleTapped(index index: Int) {
        
        let article = self.articleAtIndex(index)
        self.router.presentArticleDetails(article)
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
        
        // articles
        self.screenArticlesAmount = Int(ceil(size.height / (thumbWidth + 1))) * 2
        
        // no articles view
        self.noArticlesVisibleChanged!(visible: false)
        
        // articles
        let count = self.articlesCount
        
        if count > 0 {
            self.articlesInserted!(range: 0..<count)
        }
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        self.fetchedArticles = self.articleStorage.updateArticles(self.fetchedArticles)
        
        self.refreshing = false
        self.loadingMore = false
        
        if self.articlesCount == 0 {
            
            self.allArticlesDeleted!()
            
            if self.settings.offlineMode {
                self.noArticlesVisibleChanged!(visible: true)
            }
        }
        
        if self.fetchedArticles.count == 0 {
            self.loadFirst()
        }
        
        self.articlesUpdated!(newCount: self.articlesCount)

        self.lastReadArticleVisible = self.lastReadArticleExists
        self.navigationBarVisible = true
    }
    
    func willBeginDragging(offset offset: CGFloat) {
        self.startOffset = offset
    }
    
    func didScroll(contentOffset contentOffset: CGFloat, distanceToBottom: CGFloat) {
        
        guard self.articlesCount > 0 else {
            return
        }
        
        let bottomDirection: Bool
        
        if let _ = self.startOffset {
            bottomDirection = contentOffset - self.startOffset > 0.0
        } else {
            bottomDirection = true
        }
        
        let reachedBottom = distanceToBottom <= 0.0
        
        if (contentOffset > 64.0 && !reachedBottom && bottomDirection) {
            if self.self.navigationBarVisible == true {
                self.updateBarsVisible(false)
            }
        } else {
            if self.navigationBarVisible == false {
                self.updateBarsVisible(true)
            }
        }
        
        guard self.loading == false else {
            return
        }
        
        guard let notNilScreenSize = self.screenSize else {
            return
        }
        
        if distanceToBottom > notNilScreenSize.height * 2 {
            return
        }
        
        self.loadMore()
    }
    
    func articleModel(index index: Int) -> ArticleCellModel {
        
        let article = self.articleAtIndex(index)
        return ArticleCellModel(settings: self.settings, article: article, imageGateway: self.imageGateway)
    }
    
    func refreshTriggered() {
        
        guard !self.settings.offlineMode else {
            
            self.loadingInOfflineModeHasShown = true
            self.loadingInOfflineModeFailed!()
            
            if self.articlesCount == 0 {
                self.noArticlesVisibleChanged!(visible: true)
            }
            
            return
        }
        
        self.loadFirst()
    }
    
    func retryActionTapped() {
        
        guard !self.loading else {
            return
        }
        
        if self.articlesCount == 0 {
            self.loadFirst()
        } else {
            self.loadMore()
        }
    }
    
    func searchTapped() {
        self.router.presentSearch()
    }
    
    func settingsTapped() {
        self.router.presentSettings()
    }
    
    func lastReadArticleTapped() {
        
        guard let article = self.articleStorage.lastReadArticle else {
            return
        }
        
        self.router.presentArticleDetails(article)
    }
    
    func cancelActionTapped() {
        
        if self.articlesCount > 0 {
            return
        }
        
        self.noArticlesVisibleChanged!(visible: true)
    }
    
    func switchOffActionTapped() {
        self.router.presentSettings()
    }
    
    private func updateBarsVisible(visible: Bool) {

        if self.navigationBarVisible != visible {
            
            if self.lastReadArticleExists {
                
                self.lastReadArticleVisible = visible
                self.lastReadArticleVisibleChanged!(visible: visible, animated: true)
            }
            
            self.navigationBarVisible = visible
            self.navigationBarVisibleChanged!(visible: visible, animated: true)
        }
    }
    
    private func articleAtIndex(index: Int) -> Article {
        
        if self.fetchedArticles.count > 0 {
            return self.fetchedArticles[index]
        } else {
            return self.articleStorage.allArticles()[index]
        }
    }
    
    private func loadFirst() {
        
        guard !self.loading else {
            return
        }
        
        self.load(count: self.screenArticlesAmount * 2, willLoadHandler: {
            self.refreshing = true
        }, didLoadHandler: {
            self.refreshing = false
        })
    }
    
    private func loadMore() {
        
        guard !self.loading else {
            return
        }
        
        self.load(count: self.screenArticlesAmount * 2, willLoadHandler: {
            self.loadingMore = true
        }, didLoadHandler: {
            self.loadingMore = false
        })
    }
    
    private func load(count count: Int, willLoadHandler: (() -> Void), didLoadHandler: (() -> Void)) {
        
        if self.settings.offlineMode {
            
            if !self.loadingInOfflineModeHasShown {
                
                self.loadingInOfflineModeHasShown = true
                self.loadingInOfflineModeFailed!()
            }
            
            return
        }
        
        willLoadHandler()
        let fromIndex = self.fetchedArticles.count
        
        self.articlesFetcher.fetchArticles(fromIndex: fromIndex, count: count) { newArticles, error in
            
            guard self.viewIsPresented else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {

                didLoadHandler()
                
                if (error != nil) || self.settings.offlineMode {
                    
                    if !self.errorOccurredHasShown {
                     
                        self.errorOccurredHasShown = true
                        self.errorOccurred!()
                    }
                    
                    return
                }
                
                guard let notNilNewArticles = newArticles else {
                    return
                }
                
                guard notNilNewArticles.count > 0 else {
                    
                    self.noArticlesVisibleChanged!(visible: true)
                    return
                }
                
                let oldCount = self.fetchedArticles.count
                self.fetchedArticles.appendContentsOf(notNilNewArticles)
                
                if oldCount == 0 {                    
                    self.articlesUpdated!(newCount: notNilNewArticles.count)

                } else {
                
                    let newCount = self.fetchedArticles.count
                    self.noArticlesVisibleChanged!(visible: false)
                    self.articlesInserted!(range: fromIndex..<newCount)
                }
            })
        }
    }
}
