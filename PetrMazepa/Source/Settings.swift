//
//  Settings.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class Settings: ReadOnlySettings, ReadWriteSettings {
    
    private static let offlineModeKey = "settings_offlineMode"
    private static let onlyWifiImagesKey = "settings_onlyWifiImages"
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var offlineMode: Bool {
        didSet {

            self.userDefaults.setBool(self.offlineMode, forKey: Settings.offlineModeKey)
            self.userDefaults.synchronize()
        }
    }
    
    var onlyWifiImages: Bool {
        didSet {
            
            self.userDefaults.setBool(self.onlyWifiImages, forKey: Settings.onlyWifiImagesKey)
            self.userDefaults.synchronize()
        }
    }
    
    init() {
        
        self.offlineMode = self.userDefaults.boolForKey(Settings.offlineModeKey)
        self.onlyWifiImages = self.userDefaults.boolForKey(Settings.onlyWifiImagesKey)
    }
}
