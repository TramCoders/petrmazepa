//
//  ArticlesViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/13/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewModel : ViewModel {
    
    var loading = false {
        didSet {
            if self.viewIsPresented {
                self.loadingStateChanged!(loading: self.loading)
            }
        }
    }
    
    var articlesInserted: ((range: Range<Int>) -> Void)?
    var errorOccurred: ((error: NSError?) -> Void)?
    var loadingStateChanged: ((loading: Bool) -> Void)?
    
    private let imageGateway: ImageGateway
    private let articlesFetcher: ArticlesFetcher
    private let articleSrorage: ArticleStorage
    private let articleDetailsPresenter: ArticleDetailsPresenter
    
    private var screenSize: CGSize?
    private var thumbSize: CGSize?
    private var screenArticlesAmount: Int = 0
    
    required init(imageGateway: ImageGateway, articleStorage: ArticleStorage, articlesFetcher: ArticlesFetcher, articleDetailsPresenter: ArticleDetailsPresenter) {

        self.imageGateway = imageGateway
        self.articleSrorage = articleStorage
        self.articlesFetcher = articlesFetcher
        self.articleDetailsPresenter = articleDetailsPresenter
    }
    
    var articlesCount: Int {
        get {
            return self.articleSrorage.allArticles().count
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
        
        guard self.articlesCount == 0 else {
            return
        }
        
        // load articles
        self.screenArticlesAmount = Int(ceil(size.height / (thumbWidth + 1))) * 2
        self.loadFirst()
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
    
    func articleModel(index index: Int) -> ArticleCellModel {
        
        let article = self.articleSrorage.allArticles()[index]
        let roundedCorner = self.roundedCorner(byIndex: index)
        return ArticleCellModel(article: article, roundedCorner: roundedCorner, imageGateway: self.imageGateway)
    }
    
    func retryActionTapped() {
        
        guard self.loading == false else {
            return
        }
        
        if self.articlesCount == 0 {
            self.loadFirst()
        } else {
            self.loadMore()
        }
    }
    
    func cancelActionTapped() {
        // do nothing
    }
    
    private func loadFirst() {
        self.load(fromIndex: 0, count: self.screenArticlesAmount * 2)
    }
    
    private func loadMore() {
        
        let oldCount = self.articlesCount
        self.load(fromIndex: oldCount, count: self.screenArticlesAmount * 2)
    }
    
    private func load(fromIndex fromIndex: Int, count: Int) {
        
        self.loading = true
        
        self.articlesFetcher.fetchArticles(fromIndex: fromIndex, count: count) { articles, error in
            
            guard self.viewIsPresented else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {

                self.loading = false
                
                if let _ = error {
                    
                    self.errorOccurred!(error: error)
                    return
                }
                
                let newCount = self.articlesCount
                self.articlesInserted!(range: fromIndex..<newCount)
            })
        }
    }
    
    private func roundedCorner(byIndex index: Int) -> RoundedCorner {
        
        switch index {
            case 0: return .TopLeft
            case 1: return .TopRight
            default: return .None
        }
    }
}
