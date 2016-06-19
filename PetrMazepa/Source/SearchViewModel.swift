//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

enum SearchFilter {

    case None
    case Saved
    case Favorite
}

class SearchViewModel : ViewModel {
    
    var articlesChanged: (() -> Void)?
    
    private var query = ""
    private var allArticles: [ArticleCaption]
    private var filteredArticles: [ArticleCaption]
    private(set) var filter = SearchFilter.None
    
    private let settings: ReadOnlySettings
    private let imageGateway: ImageGateway
    private let articleStorage: ArticleStorage
    private let favouriteArticleStorage: FavouriteArticlesStorage
    private let articleContentPresenter: ArticleContentPresenter
    private let dismisser: SearchDismisser
    private let tracker: Tracker
    
    required init(settings: ReadOnlySettings, imageGateway: ImageGateway, articleStorage: ArticleStorage, favouriteArticleStorage: FavouriteArticlesStorage, articleContentPresenter: ArticleContentPresenter, dismisser: SearchDismisser, tracker: Tracker) {
        
        self.settings = settings
        self.imageGateway = imageGateway
        self.articleStorage = articleStorage
        self.favouriteArticleStorage = favouriteArticleStorage
        self.articleContentPresenter = articleContentPresenter
        self.dismisser = dismisser
        self.tracker = tracker
        
        self.allArticles = []
        self.filteredArticles = []
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        self.allArticles = self.sortedArticles(self.articleStorage.allArticles())
        self.invalidateContent()
    }
    
    func closeTapped() {
        self.dismisser.dismissSearch()
    }
    
    func filterTapped(filter: SearchFilter) {
        
        if self.filter != filter {

            self.filter = filter
            self.invalidateContent()
            self.articlesChanged!()
        }
    }
    
    func articleTapped(indexPath: NSIndexPath) {
        
        let articleCaption = self.findArticle(indexPath: indexPath)
        self.articleContentPresenter.presentArticleContent(forCaption: articleCaption)
    }
    
    func articlesCount() -> Int {
        return self.filteredArticles.count
    }
    
    func searchedArticleModel(indexPath indexPath: NSIndexPath) -> SimpleArticleCellModel {
        
        let article = self.findArticle(indexPath: indexPath)
        return SimpleArticleCellModel(settings: self.settings, article: article, imageGateway: self.imageGateway)
    }
    
    func didChangeQuery(query: String) {

        self.query = query
        self.invalidateContent()
        self.articlesChanged!()
        
        self.tracker.trackSearch(query)
    }
    
    private func invalidateContent() {
        self.filteredArticles = self.allArticles.filter(self.currentFilter())
    }
    
    private func articles(articles: [ArticleCaption], withoutArticles: [ArticleCaption]) -> [ArticleCaption] {
        
        let withoutIds = withoutArticles.map({ $0.id })
        return articles.filter({ withoutIds.contains($0.id) == false })
    }
    
    private func findArticle(indexPath indexPath: NSIndexPath) -> ArticleCaption {
        return self.filteredArticles[indexPath.row]
    }
    
    private func sortedArticles(articles: [ArticleCaption]) -> [ArticleCaption] {
        return articles.sort { $0.title < $1.title }
    }
    
    private func currentFilter() -> ((ArticleCaption) -> Bool) {
        return { article in
            return self.checkType(article) && self.checkTitle(article)
        }
    }
    
    private func checkType(article: ArticleCaption) -> Bool {
        
        switch self.filter {
        case .None: return true
        case .Favorite: return article.favourite
        case .Saved: return article.saved
        }
    }
    
    private func checkTitle(article: ArticleCaption) -> Bool {
        
        if self.query == "" {
            return true
        }
        
        return article.title.rangeOfString(self.query, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
    }
}
