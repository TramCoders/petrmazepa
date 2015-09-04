//
//  ArticlesViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/13/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewModel: ViewModel {
   
    var loading = false {
        didSet {
            if let notNilLoadingStateChanged = self.loadingStateChanged {
                notNilLoadingStateChanged(loading: self.loading)
            }
        }
    }
    
    private var articles = [SimpleArticle]()
    private var thumbImages = [Int: UIImage]()  // TODO: images will be stored in images cache object

    var articlesInserted: ((range: Range<Int>) -> Void)?
    var thumbImageLoaded: ((index: Int) -> Void)?
    var errorOccurred: ((error: NSError) -> Void)?
    var loadingStateChanged: ((loading: Bool) -> Void)?
    var searchStateChanged: ((expanded: Bool, keyboardHeight: CGFloat) -> Void)?
    
    var articlesCount: Int {
        get {
            return self.articles.count
        }
    }
    
    func requestThumb(index: Int) -> UIImage? {
        
        if let thumbImage = self.thumbImages[index] {
            return thumbImage
        }
        
        let duration = Double(arc4random_uniform(20)) / 10
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.thumbImages[index] = UIImage(named: "chersonesus")!
            
            if let notNilThumbImageLoaded = self.thumbImageLoaded {
                notNilThumbImageLoaded(index: index)
            }
        }
        
        return nil
    }
    
    func viewDidLoad() {
        
        guard self.loading == false else {
            return
        }
        
        guard self.articles.count == 0 else {
            return
        }
        
        self.load()
    }
    
    func didScrollToBottom() {
        
        guard self.loading == false else {
            return
        }
        
        self.loadMore()
    }
    
    private func loadMore() {
        
        self.loading = true
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            let oldCount = self.articles.count
            
            self.articles.append(SimpleArticle(id: "chersonesus", title: "chersonesus title"))
            self.articles.append(SimpleArticle(id: "hiroshima", title: "hiroshima title"))
            self.articles.append(SimpleArticle(id: "intermarium", title: "intermarium title"))
            
            self.loading = false
            
            let newCount = self.articles.count
            
            if let notNilArticlesInserted = self.articlesInserted {
                notNilArticlesInserted(range: oldCount..<newCount)
            }
        }
    }
    
    private func load() {
        
        self.loading = true
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.articles.append(SimpleArticle(id: "chersonesus", title: "chersonesus title"))
            self.articles.append(SimpleArticle(id: "hiroshima", title: "hiroshima title"))
            self.articles.append(SimpleArticle(id: "intermarium", title: "intermarium title"))
            self.articles.append(SimpleArticle(id: "noyou", title: "noyou title"))
            self.articles.append(SimpleArticle(id: "pm-daily374", title: "pm-daily374 title"))
            self.articles.append(SimpleArticle(id: "pm-daily375", title: "pm-daily375 title"))
            self.articles.append(SimpleArticle(id: "putinkim", title: "putinkim title"))
            self.articles.append(SimpleArticle(id: "shadowdragon", title: "shadowdragon title"))
            self.articles.append(SimpleArticle(id: "vesti", title: "shadowdragon title"))
            
            self.loading = false
            
            let newCount = self.articles.count
            
            if let notNilArticlesInserted = self.articlesInserted {
                notNilArticlesInserted(range: 0..<newCount)
            }
        }
    }
    
    func updateSearchExpanded(expanded: Bool, keyboardHeight: CGFloat) {
        
        if let notNilSearchStateChanged = self.searchStateChanged {
            notNilSearchStateChanged(expanded: expanded, keyboardHeight: keyboardHeight)
        }
    }
}
