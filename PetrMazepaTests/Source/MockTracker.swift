//
//  MockTracker.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation
@testable import PetrMazepa

class MockTracker: TrackerProtocol {
    
    var isClearImagesTracked = false
    
    func textLoadingDidStart() {}
    func trackArticleView(article: Article) {}
    func trackSearch(searchQuery: String) {}
    func trackShare(article: Article, activityType: String?) {}
    func trackFavouriteChange(article: Article) {}
    func trackOfflineModeChange(enabled: Bool) {}
    func trackOnlyWiFiImagesChange(enabled: Bool) {}
    func trackClearImages(sizeInBytes: UInt64) { isClearImagesTracked = true }
    func trackException(withDescription description: String, file: String, function: String, line: Int) {}
}