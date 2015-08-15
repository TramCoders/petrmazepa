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
    
    private(set) var articles = [ UIImage(named: "chersonesus")!,
                                  UIImage(named: "freeman")!,
                                  UIImage(named: "hiroshima")!,
                                  UIImage(named: "intermarium")!,
                                  UIImage(named: "noyou")!,
                                  UIImage(named: "pm-daily374")!,
                                  UIImage(named: "pm-daily375")!,
                                  UIImage(named: "putinkim")!,
                                  UIImage(named: "shadowdragon")!,
                                  UIImage(named: "vesti")! ]
    
    var articlesChanged: ((fromIndex: Int) -> Void)?
    
    func loadMore(completion: (() -> Void)?) {
        
        if self.loading {
            return
        }
        
        self.loading = true
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            let prevCount = self.articles.count
            
            self.articles.append(UIImage(named: "chersonesus")!)
            self.articles.append(UIImage(named: "freeman")!)
            self.articles.append(UIImage(named: "hiroshima")!)
            
            if let notNilArticlesChanged = self.articlesChanged {
                notNilArticlesChanged(fromIndex: prevCount)
            }
            
            if let notNilCompletion = completion {
                notNilCompletion()
            }
            
            self.loading = false
        }
    }
}
