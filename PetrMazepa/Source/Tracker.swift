//
//  Tracker.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 3/27/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit
import Crashlytics

class Tracker: NSObject {
    
    private var textLoadingStarted: NSDate?
    
    func textLoadingDidStart() {
        self.textLoadingStarted = NSDate()
    }
    
    func trackArticleView(article: Article) {
        
        guard let lodingStarted = self.textLoadingStarted else {
            return
        }
        
        let loadingTime = NSDate().timeIntervalSinceDate(lodingStarted)
        self.textLoadingStarted = nil
        
        Answers.logContentViewWithName(article.title, contentType: "article", contentId: article.id, customAttributes: [ "loading_time": loadingTime ])
    }
}
