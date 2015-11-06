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
    
    var thumbImageLoaded: ((indexPath: NSIndexPath) -> Void)?
    var articlesChanged: (() -> Void)?
    
    private var query = ""
    private var filteredArticles: [Article]
    private var favouriteArticles: [Article]
    
    private let imageCache: ImageCache
    private let articleStorage: ArticleStorage
    private let favouriteArticleStorage: FavouriteArticlesStorage
    private let articleDetailsPresenter: ArticleDetailsPresenter
    
    required init(imageCache: ImageCache, articleStorage: ArticleStorage, favouriteArticleStorage: FavouriteArticlesStorage, articleDetailsPresenter: ArticleDetailsPresenter) {
        
        self.imageCache = imageCache
        self.articleStorage = articleStorage
        self.favouriteArticleStorage = favouriteArticleStorage
        self.articleDetailsPresenter = articleDetailsPresenter
        
        self.filteredArticles = articleStorage.allArticles()
        self.favouriteArticles = favouriteArticleStorage.favouriteArticles()
    }
    
    func articleTapped(indexPath: NSIndexPath) {
        
        let index = indexPath.row
        let article = self.filteredArticles[index]
        self.articleDetailsPresenter.presentArticleDetails(article)
    }
    
    func articlesCount(section section: Int) -> Int {
        
        switch self.convertSection(section) {
            
            case .Favourite: return self.favouriteArticles.count
            case .Other: return self.filteredArticles.count
        }
    }
    
    func requestThumb(url url: NSURL?) -> UIImage? {
        
        guard let url = url else {
            return nil
        }
        
        var cachedImage: UIImage? = nil
        
        self.imageCache.requestImage(spec: ImageSpec(url: url, size: CGSizeMake(60, 60)), completion: { image, error, fromCache in
            
            if fromCache {

                cachedImage = image
                return
            }
            
            let indexPaths = self.findArticles(thumbUrl: url)
            
            dispatch_async(dispatch_get_main_queue(), {
                for indexPath in indexPaths {
                    self.thumbImageLoaded!(indexPath: indexPath)
                }
            })
        })
        
        return cachedImage
    }
    
    func requestArticle(indexPath: NSIndexPath) -> Article {
        
        let index = indexPath.row
        
        switch self.convertSection(indexPath.section) {
            
            case .Favourite: return self.favouriteArticles[index]
            case .Other: return self.filteredArticles[index]
        }
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
            return article.title.containsString(self.query) || article.author.containsString(self.query)
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
    
    private func convertSection(section: Int) -> SearchSection {
        return SearchSection(rawValue: section)!
    }
}
