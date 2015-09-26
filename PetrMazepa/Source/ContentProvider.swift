//
//  ContentProvider.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ContentProvider {
    
    var articles = [SimpleArticle]()
    
    private let fakeArticles = [ SimpleArticle(id: "chersonesus", title: "chersonesus title", author: "chersonesus author"),
                                 SimpleArticle(id: "hiroshima", title: "hiroshima title", author: "chersonesus author"),
                                 SimpleArticle(id: "intermarium", title: "intermarium title", author: "chersonesus author"),
                                 SimpleArticle(id: "noyou", title: "noyou title", author: "chersonesus author"),
                                 SimpleArticle(id: "pm-daily374", title: "pm-daily374 title", author: "chersonesus author"),
                                 SimpleArticle(id: "pm-daily375", title: "pm-daily375 title", author: "chersonesus author"),
                                 SimpleArticle(id: "putinkim", title: "putinkim title", author: "chersonesus author"),
                                 SimpleArticle(id: "shadowdragon", title: "shadowdragon title", author: "chersonesus author"),
                                 SimpleArticle(id: "vesti", title: "shadowdragon title", author: "chersonesus author")]
    
    func loadSimpleArticles(count: Int, completion: ([SimpleArticle]?, NSError?) -> ()) {
        
        let duration = Double(arc4random_uniform(10)) / 10
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            let newArticles = self.fakeArticles(count)
            self.articles.appendContentsOf(newArticles)
            completion(newArticles, nil)
        }
    }
    
    func loadImage(url: NSURL, completion: (NSData?, NSError?) -> ()) {
        
        let duration = Double(arc4random_uniform(20)) / 10
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            let image = UIImage(named: "chersonesus")!
            let imageData = UIImagePNGRepresentation(image)
            completion(imageData, nil)
        }
    }
    
    private func fakeArticles(count: Int) -> [SimpleArticle] {
        
        return self.fakeArticles[0..<count].map({ (article: SimpleArticle) -> SimpleArticle in
            return SimpleArticle(id: article.id, title: article.title, author: article.author)
        })
    }
    
}
