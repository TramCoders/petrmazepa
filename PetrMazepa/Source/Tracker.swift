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
    
    private static let yes = "yes"
    private static let no = "no"
    private static let contentType = "article"
    
    private var textLoadingStarted: NSDate?
    private var canceler: FireCanceler?
    
    func textLoadingDidStart() {
        self.textLoadingStarted = NSDate()
    }
    
    func trackArticleView(article: ArticleCaption) {
        
        guard let loadingStarted = self.textLoadingStarted else {
            return
        }
        
        let loadingTime = NSDate().timeIntervalSinceDate(loadingStarted)
        self.textLoadingStarted = nil
        
        Answers.logContentViewWithName(article.title, contentType: Tracker.contentType, contentId: article.id, customAttributes: [ "Loading time": NSNumber(double: loadingTime) ])
    }

    func trackSearch(searchQuery: String) {
        
        if let canceler = self.canceler {
            canceler.cancel()
        }
        
        self.canceler = Scheduler.fireBlock(after: 1) { [unowned self] in
        
            Answers.logSearchWithQuery(searchQuery, customAttributes: nil)
            self.canceler = nil
        }
    }

    static func trackShare(article: ArticleCaption, activityType: String?) {
        Answers.logShareWithMethod(activityType, contentName: article.title, contentType: Tracker.contentType, contentId: article.id, customAttributes: nil)
    }

    static func trackFavouriteChange(article: ArticleCaption) {
        Answers.logCustomEventWithName("Favorite Article", customAttributes: [ "Article ID" : article.id, "Article name" : article.title, "Favorite" : Tracker.stringFromBool(article.favourite) ])
    }
    
    static func trackOfflineModeChange(enabled: Bool) {
        Answers.logCustomEventWithName("Offline Mode", customAttributes: [ "Enabled" : Tracker.stringFromBool(enabled) ])
    }
    
    static func trackOnlyWiFiImagesChange(enabled: Bool) {
        Answers.logCustomEventWithName("Only Wi-Fi Images", customAttributes: [ "Enabled" : Tracker.stringFromBool(enabled) ])
    }
    
    static func trackClearImages(sizeInBytes: UInt64) {
        Answers.logCustomEventWithName("Clear Images", customAttributes: [ "Size in bytes" : NSNumber(unsignedLongLong: sizeInBytes) ])
    }

    static func trackException(withDescription description: String, file: String = #file, function: String = #function, line: Int = #line) {
        Answers.logCustomEventWithName(description, customAttributes: [ "File" : file, "Function" : function, "Line" : "\(line)" ])
    }
    
    private static func stringFromBool(flag: Bool) -> String {
        return flag ? Tracker.yes : Tracker.no
    }
}

extension NSError {
    public var extensiveLocalizedDescription: String? {
        get {
            return self.userInfo[NSLocalizedDescriptionKey] as? String
        }
    }
}
