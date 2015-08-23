//
//  ArticlesViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/13/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewModel: NSObject {
   
    var loading = false
    private(set) var articles = Array<UIImage>()
    var articlesInserted: ((range: Range<Int>) -> Void)?
    
    func loadIfNeeded() {
        
        guard self.articles.count == 0 else {
            return
        }
        
        guard self.loading == false else {
            return
        }
        
        self.loading = true
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.articles.append(UIImage(named: "chersonesus")!)
            self.articles.append(UIImage(named: "hiroshima")!)
            self.articles.append(UIImage(named: "intermarium")!)
            self.articles.append(UIImage(named: "noyou")!)
            self.articles.append(UIImage(named: "pm-daily374")!)
            self.articles.append(UIImage(named: "pm-daily375")!)
            self.articles.append(UIImage(named: "putinkim")!)
            self.articles.append(UIImage(named: "shadowdragon")!)
            self.articles.append(UIImage(named: "vesti")!)
            
            self.loading = false
            
            let newCount = self.articles.count
            
            if let notNilArticlesInserted = self.articlesInserted {
                notNilArticlesInserted(range: 0..<newCount)
            }
        }
    }
    
    func loadMore() {
        
        guard self.loading == false else {
            return
        }
        
        self.loading = true
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            let oldCount = self.articles.count
            
            self.articles.append(UIImage(named: "chersonesus")!)
            self.articles.append(UIImage(named: "freeman")!)
            self.articles.append(UIImage(named: "hiroshima")!)
            
            self.loading = false
            
            let newCount = self.articles.count
            
            if let notNilArticlesInserted = self.articlesInserted {
                notNilArticlesInserted(range: oldCount..<newCount)
            }
        }
    }
}
