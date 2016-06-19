//
//  ArticleContentViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleContentViewModel : ViewModel {
    
    var imageLoaded: ((image: UIImage?) -> Void)?
    var textLoaded: ((htmlText: String?) -> Void)?
    var favouriteStateChanged: ((favourite: Bool) -> Void)?
    var barsVisibilityChanged: ((visible: Bool) -> Void)?
    var errorOccurred: ((error: NSError?) -> Void)?
    
    private let articleContentDismisser: ArticleContentDismisser
    private let articleContentFetcher: ArticleContentFetcher
    private let imageGateway: ImageGateway
    private let favouriteMaker: FavouriteMaker
    private let articleSharer: ArticleSharer
    private let topOffsetEditor: TopOffsetEditor
    private let lastReadArticleMaker: LastReadArticleMaker
    private let tracker: Tracker
    
    private let settings: ReadOnlySettings
    private var articleCaption: ArticleCaption
    private var articleContent: ArticleContent?
    private var screenSize: CGSize!
    private var startOffset: CGFloat!
    
    var barsVisibile: Bool = true

    var topOffset: CGFloat {
        return CGFloat(self.articleCaption.topOffset)
    }
    
    var favourite: Bool {
        return self.articleCaption.favourite
    }
    
    var htmlText: String? {
        return self.articleContent?.htmlText
    }
    
    var image: UIImage?
    
    init(settings: ReadOnlySettings, article: ArticleCaption, imageGateway: ImageGateway, articleContentFetcher: ArticleContentFetcher, favouriteMaker: FavouriteMaker, articleContentDismisser: ArticleContentDismisser, articleSharer: ArticleSharer, topOffsetEditor: TopOffsetEditor, lastReadArticleMaker: LastReadArticleMaker, tracker: Tracker) {

        self.settings = settings
        self.articleCaption = article
        self.imageGateway = imageGateway
        self.articleContentFetcher = articleContentFetcher
        self.favouriteMaker = favouriteMaker
        self.articleContentDismisser = articleContentDismisser
        self.articleSharer = articleSharer
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
        
        self.articleCaption.topOffset = Float(offset)
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
        self.lastReadArticleMaker.setLastReadArticle(self.articleCaption)
        self.barsVisibile = true
        self.favouriteStateChanged!(favourite: self.articleCaption.favourite)
        
        self.tracker.textLoadingDidStart()
    }
    
    func viewDidAppear() {
        self.loadContent()
    }
    
    override func viewWillDisappear() {
        
        super.viewWillDisappear()
        self.topOffsetEditor.setTopOffset(self.articleCaption, offset: self.articleCaption.topOffset)
    }
    
    func textDidLoad() {
        self.tracker.trackArticleView(self.articleCaption)
    }
    
    func applicationWillResignActive() {
        self.topOffsetEditor.setTopOffset(self.articleCaption, offset: self.articleCaption.topOffset)
    }
    
    func closeActionTapped() {
        self.articleContentDismisser.dismissArticleContent()
    }
    
    func retryActionTapped() {
        self.loadContent()
    }
    
    func backTapped() {
        self.articleContentDismisser.dismissArticleContent()
    }
    
    func favouriteTapped() {
     
        guard let _ = self.articleContent else {
            return
        }
        
        let favourite = !self.articleCaption.favourite
        self.favouriteMaker.makeFavourite(article: self.articleCaption, favourite: favourite)
        self.favouriteStateChanged!(favourite: favourite)
        
        Tracker.trackFavouriteChange(self.articleCaption)
    }
    
    func shareTapped() {
        self.articleSharer.shareArticle(withCaption: self.articleCaption)
    }

    private func loadContent() {
        
        self.loadHtmlText()
        self.loadImage()
    }
    
    private func updateBarsVisible(visible: Bool) {

        self.barsVisibile = visible
        self.barsVisibilityChanged!(visible: visible)
    }
    
    private func loadHtmlText() {
        
        self.articleContentFetcher.fetchArticleContent(forCaption: self.articleCaption, allowRemote: !self.settings.offlineMode) { details, error in
            
            self.articleContent = details
            
            guard self.viewIsPresented else {
                return
            }
            
            if let notNilDetails = details {
                
                let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                let fontName = font.fontName
                let fontSize = 4    // FIXME: font.pointSize
                let updatedHtmlText = "<font face='\(fontName)' size='\(fontSize)px'>\(notNilDetails.htmlText)"
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.textLoaded!(htmlText: updatedHtmlText)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.errorOccurred!(error: error)
                })
            }
        }
    }
    
    private func loadImage() {
        
        let spec = ImageSpec(url:self.articleCaption.thumbUrl!, size: self.screenSize)
        self.imageGateway.requestImage(spec: spec, allowRemote: !self.settings.offlineMode, onlyWifi: self.settings.onlyWifiImages) { image, _, _ in
            
            self.image = image
            
            guard self.viewIsPresented else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageLoaded!(image: image)
            })
        }
    }
}
