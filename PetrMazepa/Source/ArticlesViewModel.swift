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
    private let articleSrorage: ArticleStorage
    private let articleDetailsPresenter: ArticleDetailsPresenter
    private let settingsPresenter: SettingsPresenter
    private let searchPresenter: SearchPresenter
    
    private var screenSize: CGSize?
    private var thumbSize: CGSize?
    private var screenArticlesAmount: Int = 0
    
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
    
    required init(settings: ReadOnlySettings, imageGateway: ImageGateway, articleStorage: ArticleStorage, articlesFetcher: ArticlesFetcher, articleDetailsPresenter: ArticleDetailsPresenter, settingsPresenter: SettingsPresenter, searchPresenter: SearchPresenter) {

        self.settings = settings
        self.imageGateway = imageGateway
        self.articleSrorage = articleStorage
        self.articlesFetcher = articlesFetcher
        self.articleDetailsPresenter = articleDetailsPresenter
        self.settingsPresenter = settingsPresenter
        self.searchPresenter = searchPresenter
    }
    
    var articlesCount: Int {
        get {
            return self.articleSrorage.allArticlesCount()
        }
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
        
        let article = self.articleSrorage.allArticles()[index]
        let roundedCorner = self.roundedCorner(byIndex: index)
        return ArticleCellModel(settings: self.settings, article: article, roundedCorner: roundedCorner, imageGateway: self.imageGateway)
    }
    
    func refreshTriggered() {
        
        guard !self.settings.offlineMode else {
            
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
        // do nothing
    }
    
    func switchOffActionTapped() {
        self.settingsPresenter.presentSettings()
    }
    
    private func loadFirst() {
        
        guard !self.loading else {
            return
        }
        
        self.load(fromIndex: 0, count: self.screenArticlesAmount * 2, willLoadHandler: {
            self.refreshing = true
            }, didLoadHandler: {
                self.refreshing = false
        })
    }
    
    private func loadMore() {
        
        guard !self.loading else {
            return
        }
        
        let oldCount = self.articlesCount
        
        self.load(fromIndex: oldCount, count: self.screenArticlesAmount * 2, willLoadHandler: {
            self.loadingMore = true
        }, didLoadHandler: {
            self.loadingMore = false
        })
    }
    
    private func load(fromIndex fromIndex: Int, count: Int, willLoadHandler: (() -> Void), didLoadHandler: (() -> Void)) {
        
        willLoadHandler()
        
        self.articlesFetcher.fetchArticles(fromIndex: fromIndex, count: count, allowRemote: !self.settings.offlineMode) { articles, error in
            
            guard self.viewIsPresented else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {

                didLoadHandler()
                
                if let _ = error {
                    
                    self.errorOccurred!()
                    return
                }
                
                let newCount = self.articlesCount
                
                if newCount == 0 {
//                    self.noArticlesVisibleChanged!(visible: true)
                    
                } else {
                    
//                    self.noArticlesVisibleChanged!(visible: false)
                    self.articlesInserted!(range: fromIndex..<newCount)
                }
            })
        }
    }
    
    // TODO: make a custom layout attribute
    private func roundedCorner(byIndex index: Int) -> RoundedCorner {
        
        switch index {
            
            case 0: return .TopLeft
            case 1: return .TopRight
            default: return .None
        }
    }
}
