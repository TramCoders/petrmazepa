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
            self.loadingStateChanged!(loading: self.loading)
        }
    }
    
    private var articles = [SimpleArticle]()
    private var thumbImages = [Int: UIImage]()  // TODO: images will be stored in images cache object

    var articlesInserted: ((range: Range<Int>) -> Void)?
    var thumbImageLoaded: ((index: Int) -> Void)?
    var errorOccurred: ((error: NSError) -> Void)?
    var loadingStateChanged: ((loading: Bool) -> Void)?
    
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
            self.thumbImageLoaded!(index: index)
        }
        
        return nil
    }
    
    func searchTapped() {
        self.screenFlow.showSearch()
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
            
            self.articles.append(SimpleArticle(id: "chersonesus", title: "chersonesus title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "hiroshima", title: "hiroshima title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "intermarium", title: "intermarium title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "hiroshima", title: "hiroshima title", author: "chersonesus author"))
            
            self.loading = false
            
            let newCount = self.articles.count
            self.articlesInserted!(range: oldCount..<newCount)
        }
    }
    
    private func load() {
        
        self.loading = true
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.articles.append(SimpleArticle(id: "chersonesus", title: "chersonesus title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "hiroshima", title: "hiroshima title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "intermarium", title: "intermarium title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "noyou", title: "noyou title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "pm-daily374", title: "pm-daily374 title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "pm-daily375", title: "pm-daily375 title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "putinkim", title: "putinkim title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "shadowdragon", title: "shadowdragon title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "vesti", title: "shadowdragon title", author: "chersonesus author"))
            self.articles.append(SimpleArticle(id: "vesti", title: "shadowdragon title", author: "chersonesus author"))
            
            self.loading = false
            
            let newCount = self.articles.count
            self.articlesInserted!(range: 0..<newCount)
        }
    }
    
}
