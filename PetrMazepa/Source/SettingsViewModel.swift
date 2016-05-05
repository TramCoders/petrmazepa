//
//  SettingsViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    private let settings: ReadWriteSettings
    private let router: RouterNavigation
    private let imageCacheUtil: ImageCacheUtil
    private let tracker: Tracker
    
    init(settings: ReadWriteSettings, router: RouterNavigation, imageCacheUtil: ImageCacheUtil, tracker: Tracker) {

        self.settings = settings
        self.router = router
        self.imageCacheUtil = imageCacheUtil
        self.tracker = tracker
    }
    
    var offlineMode: Bool {
        return self.settings.offlineMode
    }
    
    var onlyWifiImages: Bool {
        return self.settings.onlyWifiImages
    }
    
    var imageCacheSize: UInt64 {
        return self.imageCacheUtil.sizeInBytes
    }
    
    func closeTapped() {
        self.router.dismissSettings()
    }
    
    func didSwitchOfflineMode(enabled enabled: Bool) {

        self.settings.offlineMode = enabled
        self.tracker.trackOfflineModeChange(enabled)
    }
    
    func didSwitchOnlyWifiImages(enabled enabled: Bool) {
        
        self.settings.onlyWifiImages = enabled
        self.tracker.trackOnlyWiFiImagesChange(enabled)
    }
    
    func clearCacheTapped() {
        
        self.tracker.trackClearImages(self.imageCacheUtil.sizeInBytes)
        self.imageCacheUtil.clearCache()
    }
}
