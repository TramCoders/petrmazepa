//
//  ArticleDetailsViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewModel : ViewModel, IArticleDetailsViewModel {
    
    var view: IArticleDetailsView?
    
    private let articleDetailsFetcher: ArticleDetailsFetcher
    private let imageGateway: ImageGateway
    private let favouriteMaker: FavouriteMaker
    private let router: IRouter
    private let topOffsetEditor: TopOffsetEditor
    private let lastReadArticleMaker: LastReadArticleMaker
    private let tracker: Tracker
    
    private let settings: ReadOnlySettings
    private let article: Article
    private var articleDetails: ArticleDetails?
    private var screenSize: CGSize!
    private var startOffset: CGFloat!
    
    private(set) var barsVisibile: Bool = true

    var topOffset: CGFloat {
        return CGFloat(self.article.topOffset)
    }
    
    var favourite: Bool {
        return self.article.favourite
    }
    
    var htmlText: String? {
        
        guard let notNilDetails = self.articleDetails else {
            return nil
        }
        
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        let fontName = font.fontName
        let fontSize = 4    // FIXME: font.pointSize
        return "<font face='\(fontName)' size='\(fontSize)px'>\(notNilDetails.htmlText)"
    }
    
    private(set) var image: UIImage?
    
    init(view: IArticleDetailsView, settings: ReadOnlySettings, article: Article, imageGateway: ImageGateway, articleDetailsFetcher: ArticleDetailsFetcher, favouriteMaker: FavouriteMaker, router: IRouter, topOffsetEditor: TopOffsetEditor, lastReadArticleMaker: LastReadArticleMaker, tracker: Tracker) {

        self.view = view
        self.settings = settings
        self.article = article
        self.imageGateway = imageGateway
        self.articleDetailsFetcher = articleDetailsFetcher
        self.favouriteMaker = favouriteMaker
        self.router = router
        self.topOffsetEditor = topOffsetEditor
        self.lastReadArticleMaker = lastReadArticleMaker
        self.tracker = tracker
    }
    
    func viewDidLayoutSubviews(screenSize size: CGSize) {
        self.screenSize = size
    }
    
    func scrollViewWillBeginDragging(offset offset: CGFloat) {
        self.startOffset = offset
    }
    
    func scrollViewDidScroll(offset offset: CGFloat, contentHeight: CGFloat) {
        
        self.article.topOffset = Double(offset.native)
        let bottomDirection: Bool
        
        if let _ = self.startOffset {
            bottomDirection = (offset > 20.0) && (offset - self.startOffset > 0.0)
        } else {
            bottomDirection = true
        }
        
        let reachedBottom = contentHeight - offset - self.screenSize.height <= 0.0
        
        if (!reachedBottom && bottomDirection) {
            if self.barsVisibile == true {
                self.updateBarsVisible(false)
            }
        } else {
            if self.barsVisibile == false {
                self.updateBarsVisible(true)
            }
        }
    }
    
    override func viewWillAppear() {

        super.viewWillAppear()
        self.lastReadArticleMaker.setLastReadArticle(self.article)
        self.barsVisibile = true
        self.view?.updateFavouriteState(self.article.favourite)
        
        self.tracker.textLoadingDidStart()
    }
    
    func viewDidAppear() {
        self.loadContent()
    }
    
    override func viewWillDisappear() {
        
        super.viewWillDisappear()
        self.topOffsetEditor.setTopOffset(self.article, offset: self.article.topOffset)
    }
    
    func textDidLoad() {
        self.tracker.trackArticleView(self.article)
    }
    
    func applicationWillResignActive() {
        self.topOffsetEditor.setTopOffset(self.article, offset: self.article.topOffset)
    }
    
    func closeActionTapped() {
        self.router.dismissArticleDetails()
    }
    
    func retryActionTapped() {
        self.loadContent()
    }
    
    func backTapped() {
        self.router.dismissArticleDetails()
    }
    
    func favouriteTapped() {
     
        guard let _ = self.articleDetails else {
            return
        }
        
        let favourite = !self.article.favourite
        self.favouriteMaker.makeFavourite(article: self.article, favourite: favourite)
        self.view?.updateFavouriteState(favourite)
        
        Tracker.trackFavouriteChange(self.article)
    }
    
    func shareTapped() {
        self.router.shareArticle(self.article)
    }
    
    private func loadContent() {
        
        self.loadHtmlText()
        self.loadImage()
    }
    
    private func updateBarsVisible(visible: Bool) {

        self.barsVisibile = visible
        self.view?.updateBarsVisibility(visible)
    }
    
    private func loadHtmlText() {
        
        self.articleDetailsFetcher.fetchArticleDetails(article: self.article, allowRemote: !self.settings.offlineMode) { details, error in
            
            self.articleDetails = details
            
            guard self.viewIsPresented else {
                return
            }
            
            guard details != nil else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.view?.showError(error)
                })
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.view?.reloadHtmlText()
            })
        }
    }
    
    private func loadImage() {
        
        let spec = ImageSpec(url:self.article.thumbUrl!, size: self.screenSize)
        self.imageGateway.requestImage(spec: spec, allowRemote: !self.settings.offlineMode, onlyWifi: self.settings.onlyWifiImages) { image, _, _ in
            
            self.image = image
            
            guard self.viewIsPresented else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.view?.reloadImage()
            })
        }
    }
}
