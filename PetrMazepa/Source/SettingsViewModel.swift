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
    private let router: IRouter
    private let imageCacheUtil: ImageCacheUtil
    private let tracker: Tracker
    
    init(settings: ReadWriteSettings, router: IRouter, imageCacheUtil: ImageCacheUtil, tracker: Tracker) {

        self.settings = settings
        self.router = router
        self.imageCacheUtil = imageCacheUtil
        self.tracker = tracker;
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
        Tracker.trackOfflineModeChange(enabled)
    }
    
    func didSwitchOnlyWifiImages(enabled enabled: Bool) {
        
        self.settings.onlyWifiImages = enabled
        Tracker.trackOnlyWiFiImagesChange(enabled)
    }
    
    func clearCacheTapped() {
        
        Tracker.trackClearImages(self.imageCacheUtil.sizeInBytes)
        self.imageCacheUtil.clearCache()
    }
}
