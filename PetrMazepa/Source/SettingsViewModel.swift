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
    
    init(settings: ReadWriteSettings) {
        self.settings = settings
    }
    
    var offlineMode: Bool {
        return self.settings.offlineMode
    }
    
    var onlyWifiImages: Bool {
        return self.settings.onlyWifiImages
    }
    
    func didSwitchOfflineMode(enabled enabled: Bool) {
        self.settings.offlineMode = enabled
    }
    
    func didSwitchOnlyWifiImages(enabled enabled: Bool) {
        self.settings.onlyWifiImages = enabled
    }
}
