//
//  ReadOnlySettings.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ReadOnlySettings: class {
    
    var offlineMode: Bool { get }
    var onlyWifiImages: Bool { get }
}
