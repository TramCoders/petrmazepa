//
//  SettingsViewModelProtocol.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol SettingsViewModelProtocol {
    
    var offlineMode: Bool { get }
    var onlyWifiImages: Bool { get }
    var imageCacheSize: UInt64 { get }
    
    func didSwitchOfflineMode(enabled enabled: Bool)
    func didSwitchOnlyWifiImages(enabled enabled: Bool)
    func closeTapped()
    func clearCacheTapped()
}
