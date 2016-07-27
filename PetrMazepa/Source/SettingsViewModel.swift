//
//  SettingsViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class SettingsViewModel: SettingsViewModelProtocol {
    
    private var view: SettingsViewProtocol
    
    private let settings: ReadWriteSettings
    private let router: IRouter
    private let imageCacheUtil: ImageCacheUtil
    private let tracker: ITracker
    
    init(view: SettingsViewProtocol, settings: ReadWriteSettings, router: IRouter, imageCacheUtil: ImageCacheUtil, tracker: ITracker) {

        self.view = view
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
        tracker.trackOfflineModeChange(enabled)
    }
    
    func didSwitchOnlyWifiImages(enabled enabled: Bool) {
        
        self.settings.onlyWifiImages = enabled
        tracker.trackOnlyWiFiImagesChange(enabled)
    }
    
    func clearCacheTapped() {
        
        tracker.trackClearImages(self.imageCacheUtil.sizeInBytes)
        self.imageCacheUtil.clearCache()
    }
}
