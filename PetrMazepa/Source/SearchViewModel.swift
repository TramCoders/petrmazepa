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
    private var favouriteArticles: [Article]
    
    private let imageGateway: ImageGateway
    private let articleStorage: ArticleStorage
    private let favouriteArticleStorage: FavouriteArticlesStorage
    private let articleDetailsPresenter: ArticleDetailsPresenter
    
    required init(imageGateway: ImageGateway, articleStorage: ArticleStorage, favouriteArticleStorage: FavouriteArticlesStorage, articleDetailsPresenter: ArticleDetailsPresenter) {
        
        self.imageGateway = imageGateway
        self.articleStorage = articleStorage
        self.favouriteArticleStorage = favouriteArticleStorage
        self.articleDetailsPresenter = articleDetailsPresenter
        
        self.filteredArticles = articleStorage.allArticles()
        self.favouriteArticles = favouriteArticleStorage.favouriteArticles()
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        self.favouriteArticles = favouriteArticleStorage.favouriteArticles()
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
        return SearchedArticleCellModel(article: article, imageGateway: self.imageGateway)
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
            return article.title.containsString(self.query)
        })
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
