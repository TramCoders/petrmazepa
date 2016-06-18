//
//  SettingsModule.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 18/06/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol ISettingsViewModel {
    
    var offlineMode: Bool { get }
    var onlyWifiImages: Bool { get }
    var imageCacheSize: UInt64 { get }
    
    func didSwitchOfflineMode(enabled enabled: Bool)
    func didSwitchOnlyWifiImages(enabled enabled: Bool)
    func closeTapped()
    func clearCacheTapped()
}

protocol ISettingsView {
    
}
