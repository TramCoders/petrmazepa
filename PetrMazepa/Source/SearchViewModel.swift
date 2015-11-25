//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel : ViewModel {
    
    enum SearchSection: Int {
        
        case Favourite
        case Other
    }
    
    var articlesChanged: (() -> Void)?
    
    private var query = ""
    private var filteredArticles: [Article]
    private var allFavouriteArticles: [Article]
    private var favouriteArticles: [Article]
    
    private let settings: ReadOnlySettings
    private let imageGateway: ImageGateway
    private let articleStorage: ArticleStorage
    private let favouriteArticleStorage: FavouriteArticlesStorage
    private let articleDetailsPresenter: ArticleDetailsPresenter
    
    required init(settings: ReadOnlySettings, imageGateway: ImageGateway, articleStorage: ArticleStorage, favouriteArticleStorage: FavouriteArticlesStorage, articleDetailsPresenter: ArticleDetailsPresenter) {
        
        self.settings = settings
        self.imageGateway = imageGateway
        self.articleStorage = articleStorage
        self.favouriteArticleStorage = favouriteArticleStorage
        self.articleDetailsPresenter = articleDetailsPresenter
        
        self.filteredArticles = []
        self.allFavouriteArticles = []
        self.favouriteArticles = []
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        self.allFavouriteArticles = self.favouriteArticleStorage.favouriteArticles()
        self.invalidateContent()
    }
    
    func articleTapped(indexPath: NSIndexPath) {
        
        let index = indexPath.row
        let section = indexPath.section
        let article: Article
        
        switch self.convertSection(section) {
            
            case .Favourite: article = self.favouriteArticles[index]
            case .Other: article = self.filteredArticles[index]
        }
        
        self.articleDetailsPresenter.presentArticleDetails(article)
    }
    
    func articlesCount(section section: Int) -> Int {
        
        switch self.convertSection(section) {
            
            case .Favourite: return self.favouriteArticles.count
            case .Other: return self.filteredArticles.count
        }
    }
    
    func searchedArticleModel(indexPath indexPath: NSIndexPath) -> SearchedArticleCellModel {
        
        let article = self.findArticle(indexPath: indexPath)
        return SearchedArticleCellModel(settings: self.settings, article: article, imageGateway: self.imageGateway)
    }
    
    func didChangeQuery(query: String) {

        self.query = query
        self.invalidateContent()
        self.articlesChanged!()
    }
    
    private func invalidateContent() {
        
        if self.query == "" {

            self.favouriteArticles = self.allFavouriteArticles
            self.filteredArticles = self.articles(self.articleStorage.allArticles(), withoutArticles: self.allFavouriteArticles)
            return
        }
        
        let filter = { (article: Article) in
            return article.title.rangeOfString(self.query, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
        }
        
        let articles = self.articles(self.articleStorage.allArticles(), withoutArticles: self.allFavouriteArticles)
        self.filteredArticles = articles.filter(filter)
        self.favouriteArticles = self.allFavouriteArticles.filter(filter)
    }
    
    private func articles(articles: [Article], withoutArticles: [Article]) -> [Article] {
        
        let withoutIds = withoutArticles.map({ $0.id })
        return articles.filter({ withoutIds.contains($0.id) == false })
    }
    
    private func findArticles(thumbUrl url: NSURL) -> [NSIndexPath] {
        
        var indexPaths = [NSIndexPath]()
        
        if let favouriteIndex = self.favouriteArticles.indexOf({ $0.thumbUrl == url }) {
            indexPaths.append(NSIndexPath(forRow: favouriteIndex, inSection: 0))
        }
        
        if let otherIndex = self.filteredArticles.indexOf({ $0.thumbUrl == url }) {
            indexPaths.append(NSIndexPath(forRow: otherIndex, inSection: 1))
        }
        
        return indexPaths
    }
    
    private func findArticle(indexPath indexPath: NSIndexPath) -> Article {
        
        let index = indexPath.row
        
        switch self.convertSection(indexPath.section) {
            
            case .Favourite: return self.favouriteArticles[index]
            case .Other: return self.filteredArticles[index]
        }
    }
    
    private func convertSection(section: Int) -> SearchSection {
        return SearchSection(rawValue: section)!
    }
}
