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
    
    private var thumbImages = [Int: UIImage]()  // TODO: images will be stored in images cache object

    var articlesInserted: ((range: Range<Int>) -> Void)?
    var thumbImageLoaded: ((index: Int) -> Void)?
    var errorOccurred: ((error: NSError) -> Void)?
    var loadingStateChanged: ((loading: Bool) -> Void)?
    
    var articlesCount: Int {
        get {
            return self.contentProvider.articles.count
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
    
    func viewDidLoad() {
        
        guard self.loading == false else {
            return
        }
        
        guard self.contentProvider.articles.count == 0 else {
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
        let oldCount = self.contentProvider.articles.count
        
        self.contentProvider.loadSimpleArticles(4) { (articles: [SimpleArticle]?, error: NSError?) -> () in
            
            self.loading = false
            let newCount = self.contentProvider.articles.count
            self.articlesInserted!(range: oldCount..<newCount)
        }
    }
    
    private func load() {
        
        self.loading = true
        
        self.contentProvider.loadSimpleArticles(8) { (articles: [SimpleArticle]?, error: NSError?) -> () in
            
            self.loading = false
            let newCount = self.contentProvider.articles.count
            self.articlesInserted!(range: 0..<newCount)
        }
    }
    
}
