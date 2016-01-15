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
    var loadingInOfflineModeFailed: (() -> Void)?
    var errorOccurred: (() -> Void)?
    var refreshingStateChanged: ((refreshing: Bool) -> Void)?
    var loadingMoreStateChanged: ((loadingMore: Bool) -> Void)?
    var noArticlesVisibleChanged: ((visible: Bool) -> Void)?
    
    private let settings: ReadOnlySettings
    private let imageGateway: ImageGateway
    private let articlesFetcher: ArticlesFetcher
    private let articleDetailsPresenter: ArticleDetailsPresenter
    private let settingsPresenter: SettingsPresenter
    private let searchPresenter: SearchPresenter
    
    private var articles = [Article]()
    
    private var screenSize: CGSize?
    private var thumbSize: CGSize?
    private var screenArticlesAmount: Int = 0
    private var loadingInOfflineModeHasShown = false
    
    var articlesCount: Int {
        return self.articles.count
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
    
    required init(settings: ReadOnlySettings, imageGateway: ImageGateway, articlesFetcher: ArticlesFetcher, articleDetailsPresenter: ArticleDetailsPresenter, settingsPresenter: SettingsPresenter, searchPresenter: SearchPresenter) {

        self.settings = settings
        self.imageGateway = imageGateway
        self.articlesFetcher = articlesFetcher
        self.articleDetailsPresenter = articleDetailsPresenter
        self.settingsPresenter = settingsPresenter
        self.searchPresenter = searchPresenter
    }
    
    func articleTapped(index index: Int) {
        
        let article = self.articles[index]
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
        
        self.refreshing = false
        self.loadingMore = false
        
        if self.articlesCount == 0 {
            
            self.allArticlesDeleted!()
            
            if self.settings.offlineMode {
                self.noArticlesVisibleChanged!(visible: true)
            }
            
            self.loadFirst()
        }
    }
    
    func didChangeDistanceToBottom(distance: CGFloat) {
        
        guard self.articlesCount > 0 else {
            return
        }
        
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
    
    func articleModel(index index: Int) -> ArticleCellModel {
        
        let article = self.articles[index]
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
        self.searchPresenter.presentSearch()
    }
    
    func settingsTapped() {
        self.settingsPresenter.presentSettings()
    }
    
    func cancelActionTapped() {
        
        if self.articlesCount > 0 {
            return
        }
        
        self.noArticlesVisibleChanged!(visible: true)
    }
    
    func switchOffActionTapped() {
        self.settingsPresenter.presentSettings()
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
        let fromIndex = self.articlesCount
        
        self.articlesFetcher.fetchArticles(fromIndex: fromIndex, count: count) { newArticles, error in
            
            guard self.viewIsPresented else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {

                didLoadHandler()
                
                if (error != nil) || self.settings.offlineMode {
                    
                    self.errorOccurred!()
                    return
                }
                
                guard let notNilNewArticles = newArticles else {
                    return
                }
                
                self.articles.appendContentsOf(notNilNewArticles)
                let newCount = self.articlesCount
                
                if newCount == 0 {
                    self.noArticlesVisibleChanged!(visible: true)
                    
                } else {
                    
                    self.noArticlesVisibleChanged!(visible: false)
                    self.articlesInserted!(range: fromIndex..<newCount)
                }
            })
        }
    }
}
