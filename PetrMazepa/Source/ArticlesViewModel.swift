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
    
    var articlesInserted: ((range: Range<Int>) -> Void)?
    var errorOccurred: ((error: NSError) -> Void)?
    var loadingStateChanged: ((loading: Bool) -> Void)?
    
    var articlesCount: Int {
        get {
            return self.contentProvider.articles.count
        }
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
        
        let oldCount = self.contentProvider.articles.count
        self.load(fromIndex: oldCount, count: 4)
    }
    
    private func load() {
        self.load(fromIndex: 0, count: 8)
    }
    
    private func load(fromIndex fromIndex: Int, count: Int) {
        
        self.loading = true
        
        self.contentProvider.loadSimpleArticles(8) { (articles: [SimpleArticle]?, error: NSError?) -> () in
            
            self.loading = false
            let newCount = self.contentProvider.articles.count
            self.articlesInserted!(range: fromIndex..<newCount)
        }
    }
}
