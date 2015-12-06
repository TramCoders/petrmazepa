//
//  ArticleDetailsViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewModel : ViewModel {
    
    var imageLoaded: ((image: UIImage?) -> Void)?
    var textLoaded: ((htmlText: String?) -> ())?
    var favouriteStateChanged: ((favourite: Bool) -> Void)?
    var barsVisibilityChanged: ((visible: Bool) -> Void)?
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
    private var startOffset: CGFloat!
    
    var barsVisibile: Bool = true
    
    var favourite: Bool {
        return self.article.favourite
    }
    
    var htmlText: String? {
        return self.articleDetails?.htmlText
    }
    
    var image: UIImage?
    
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
    
    func scrollViewWillBeginDragging(offset offset: CGFloat) {
        self.startOffset = offset
    }
    
    func scrollViewWillEndDragging(offset offset: CGFloat) {
        
        if (offset - self.startOffset > 0) {
            
            if self.barsVisibile == true {
                
                self.barsVisibile = false
                self.barsVisibilityChanged!(visible: self.barsVisibile)
            }
            
        } else {
            
            if self.barsVisibile == false {
                
                self.barsVisibile = true
                self.barsVisibilityChanged!(visible: self.barsVisibile)
            }
        }
    }
    
    override func viewWillAppear() {

        super.viewWillAppear()
        self.barsVisibile = true
    }
    
    func viewDidAppear() {
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
    
    private func loadContent() {
        
        self.loadHtmlText()
        self.loadImage()
    }
    
    private func loadHtmlText() {
        
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
                    self.textLoaded!(htmlText: updatedHtmlText)
                })
            } else {
                self.errorOccurred!(error: error)
            }
        }
    }
    
    private func loadImage() {
        
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
