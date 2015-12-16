//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel : ViewModel {
    
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
    private let dismisser: SearchDismisser
    
    required init(settings: ReadOnlySettings, imageGateway: ImageGateway, articleStorage: ArticleStorage, favouriteArticleStorage: FavouriteArticlesStorage, articleDetailsPresenter: ArticleDetailsPresenter, dismisser: SearchDismisser) {
        
        self.settings = settings
        self.imageGateway = imageGateway
        self.articleStorage = articleStorage
        self.favouriteArticleStorage = favouriteArticleStorage
        self.articleDetailsPresenter = articleDetailsPresenter
        self.dismisser = dismisser
        
        self.filteredArticles = []
        self.allFavouriteArticles = []
        self.favouriteArticles = []
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        self.allFavouriteArticles = self.favouriteArticleStorage.favouriteArticles()
        self.invalidateContent()
    }
    
    func closeTapped() {
        self.dismisser.dismissSearch()
    }
    
    func articleTapped(indexPath: NSIndexPath) {
        
        let article = self.findArticle(indexPath: indexPath)
        self.articleDetailsPresenter.presentArticleDetails(article)
    }
    
    func sectionsCount() -> Int {
        
        let favoritesCount = self.favouriteArticles.count
        let othersCount = self.filteredArticles.count
        
        if (favoritesCount > 0) && (othersCount > 0) {
            return 2
        } else if (favoritesCount == 0) && (othersCount == 0) {
            return 0
        } else {
            return 1
        }
    }
    
    func sectionHeadersVisible() -> Bool {
        
        let favoritesCount = self.allFavouriteArticles.count
        return favoritesCount == 0 ? false : true
    }
    
    func sectionTitleKey(section section: Int) -> String {
        
        let favoritesCount = self.favouriteArticles.count
        
        if (favoritesCount > 0) && (section == 0) {
            return "FavoriteSectionTitle"
        } else {
            return "OthersSectionTitle"
        }
    }
    
    func articlesCount(section section: Int) -> Int {
        
        let favoritesCount = self.favouriteArticles.count
        
        if (favoritesCount > 0) && (section == 0) {
            return favoritesCount
        } else {
            return self.filteredArticles.count
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
    
    private func findArticle(indexPath indexPath: NSIndexPath) -> Article {
        
        let index = indexPath.row
        let favoritesCount = self.favouriteArticles.count
        
        if (favoritesCount > 0) && (indexPath.section == 0) {
            return self.favouriteArticles[index]
        } else {
            return self.filteredArticles[index]
        }
    }
}
