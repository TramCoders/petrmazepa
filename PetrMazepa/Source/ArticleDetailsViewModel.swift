//
//  ArticleDetailsViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewModel {
    
    var loadingStateChanged: ((loading: Bool) -> Void)?
    var imageLoaded: ((image: UIImage?) -> Void)?
    var articleDetailsLoaded: ((dateString: String?, author: String?, htmlText: String?) -> ())?
    var errorOccurred: ((error: NSError) -> Void)?
    
    private let articleDetailsDismisser: ArticleDetailsDismisser
    private let articleDetailsFetcher: ArticleDetailsFetcher
    private let imageCache: ImageCache
    private let articleSharer: ArticleSharer
    
    private let article: Article
    private var articleDetails: ArticleDetails?
    
    init(article: Article, imageCache: ImageCache, articleDetailsFetcher: ArticleDetailsFetcher, articleDetailsDismisser: ArticleDetailsDismisser, articleSharer: ArticleSharer) {

        self.article = article
        self.imageCache = imageCache
        self.articleDetailsFetcher = articleDetailsFetcher
        self.articleDetailsDismisser = articleDetailsDismisser
        self.articleSharer = articleSharer
    }
    
    func viewDidLoad() {
        
        self.imageLoaded!(image: nil)
        self.articleDetailsLoaded!(dateString: nil, author: self.article.author, htmlText: nil)
        
        self.articleDetailsFetcher.fetchArticleDetails(article: self.article) { details, error in
            
            self.articleDetails = details
            
            if let notNilDetails = details {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.articleDetailsLoaded!(dateString: notNilDetails.dateString, author: notNilDetails.author, htmlText: notNilDetails.htmlText)
                })
            }
        }
        
        self.imageCache.requestImage(url: self.article.thumbUrl!) { imageData, error, fromCache in
            
            guard let notNilImageData = imageData else {
                return
            }
            
            let image = UIImage(data: notNilImageData)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageLoaded!(image: image)
            })
        }
    }
    
    func backTapped() {
        self.articleDetailsDismisser.dismissArticleDetails()
    }
    
    func shareTapped() {
        self.articleSharer.shareArticle(self.article)
    }
}
