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
    private let dismisser: SettingsDismisser
    private let imageCacheUtil: ImageCacheUtil
    
    init(settings: ReadWriteSettings, dismisser: SettingsDismisser, imageCacheUtil: ImageCacheUtil) {

        self.settings = settings
        self.dismisser = dismisser
        self.imageCacheUtil = imageCacheUtil
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
        self.dismisser.dismissSettings()
    }
    
    func didSwitchOfflineMode(enabled enabled: Bool) {
        self.settings.offlineMode = enabled
    }
    
    func didSwitchOnlyWifiImages(enabled enabled: Bool) {
        self.settings.onlyWifiImages = enabled
    }
    
    func clearCacheTapped() {
        
        self.imageCacheUtil.clearCache()
    }
}
