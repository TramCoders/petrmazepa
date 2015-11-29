//
//  ArticleDetailsViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewModel : ViewModel {
    
    var loadingStateChanged: ((loading: Bool) -> Void)?
    var imageLoaded: ((image: UIImage?) -> Void)?
    var articleDetailsLoaded: ((htmlText: String?) -> ())?
    var favouriteStateChanged: ((favourite: Bool) -> Void)?
    var errorOccurred: ((error: NSError?) -> Void)?
    
    private let articleDetailsDismisser: ArticleDetailsDismisser
    private let articleDetailsFetcher: ArticleDetailsFetcher
    private let imageGateway: ImageGateway
    private let favouriteMaker: FavouriteMaker
    private let articleSharer: ArticleSharer
    
    private let settings: ReadOnlySettings
    private let article: Article
    private var articleDetails: ArticleDetails?
    private var screenSize: CGSize!
    
    var favourite: Bool {
        return self.article.favourite
    }
    
    init(settings: ReadOnlySettings, article: Article, imageGateway: ImageGateway, articleDetailsFetcher: ArticleDetailsFetcher, favouriteMaker: FavouriteMaker, articleDetailsDismisser: ArticleDetailsDismisser, articleSharer: ArticleSharer) {

        self.settings = settings
        self.article = article
        self.imageGateway = imageGateway
        self.articleDetailsFetcher = articleDetailsFetcher
        self.favouriteMaker = favouriteMaker
        self.articleDetailsDismisser = articleDetailsDismisser
        self.articleSharer = articleSharer
    }
    
    func viewDidLayoutSubviews(screenSize size: CGSize) {
        self.screenSize = size
    }
    
    func viewDidAppear() {
        
        self.imageLoaded!(image: nil)
        self.articleDetailsLoaded!(htmlText: nil)
        self.favouriteStateChanged!(favourite: self.favourite)
        self.loadContent()
    }
    
    func closeActionTapped() {
        self.articleDetailsDismisser.dismissArticleDetails()
    }
    
    func retryActionTapped() {
        self.loadContent()
    }
    
    func backTapped() {
        self.articleDetailsDismisser.dismissArticleDetails()
    }
    
    func favouriteTapped() {
     
        guard let details = self.articleDetails else {
            return
        }
        
        let favourite = !self.article.favourite
        self.favouriteMaker.makeFavourite(article: self.article, details:  details, favourite: favourite)

        if self.viewIsPresented {
            self.favouriteStateChanged!(favourite: favourite)
        }
    }
    
    func shareTapped() {
        self.articleSharer.shareArticle(self.article)
    }
    
    func loadContent() {
        
        self.articleDetailsFetcher.fetchArticleDetails(article: self.article, allowRemote: !self.settings.offlineMode) { details, error in
            
            self.articleDetails = details
            
            guard self.viewIsPresented else {
                return
            }
            
            if let notNilDetails = details {
                
                let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                let fontName = font.fontName
                let fontSize = 4    //FIXME: font.pointSize
                let updatedHtmlText = "<font face='\(fontName)' size='\(fontSize)px'>\(notNilDetails.htmlText)"
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.articleDetailsLoaded!(htmlText: updatedHtmlText)
                })
            } else {
                self.errorOccurred!(error: error)
            }
        }
        
        let spec = ImageSpec(url:self.article.thumbUrl!, size: self.screenSize)
        self.imageGateway.requestImage(spec: spec, allowRemote: !self.settings.offlineMode, onlyWifi: self.settings.onlyWifiImages) { image, _, _ in
            
            guard self.viewIsPresented else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageLoaded!(image: image)
            })
        }
    }
}
