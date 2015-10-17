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
    
    private let article: Article
    private var screenSize: CGSize!
    
    init(article: Article, imageCache: ImageCache, articleDetailsFetcher: ArticleDetailsFetcher, articleDetailsDismisser: ArticleDetailsDismisser) {

        self.article = article
        self.imageCache = imageCache
        self.articleDetailsFetcher = articleDetailsFetcher
        self.articleDetailsDismisser = articleDetailsDismisser
    }
    
    func viewDidLayoutSubviews(screenSize size: CGSize) {
        self.screenSize = size
    }
    
    func viewDidAppear() {
        
        self.imageLoaded!(image: nil)
        self.articleDetailsLoaded!(dateString: nil, author: self.article.author, htmlText: nil)
        
        self.articleDetailsFetcher.fetchArticleDetails(article: self.article) { details, error in
            
            if let notNilDetails = details {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.articleDetailsLoaded!(dateString: notNilDetails.dateString, author: notNilDetails.author, htmlText: notNilDetails.htmlText)
                })
            }
        }
        
        self.imageCache.requestImage(spec: ImageSpec(url:self.article.thumbUrl!, size: self.screenSize)) { image, _, _ in
            dispatch_async(dispatch_get_main_queue(), {
                self.imageLoaded!(image: image)
            })
        }
    }
    
    func backTapped() {
        self.articleDetailsDismisser.dismissArticleDetails()
    }
}