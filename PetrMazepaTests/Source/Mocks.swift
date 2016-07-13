//
//  Mocks.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 13/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation
@testable import PetrMazepa

class MockedSettingsView: ISettingsView {
    
}

class MockedReadWriteSettings: ReadWriteSettings {
    
    var offlineMode: Bool = false
    var onlyWifiImages: Bool = false
}

class MockedRouter: IRouter {
    
    var isSettingsDismissed: Bool = false
    
    func presentArticles() {}
    func presentArticleDetails(article: Article) {}
    func dismissArticleDetails() {}
    func presentSettings() {}
    func dismissSettings() { isSettingsDismissed = true }
    func presentSearch() {}
    func dismissSearch() {}
    func shareArticle(article: Article) {}
}

class MockedImageCacheUtil: ImageCacheUtil {
    
    private(set) var sizeInBytes: UInt64 = 10
    func clearCache() { sizeInBytes = 0 }
}

class MockedTracker: ITracker {
    
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
