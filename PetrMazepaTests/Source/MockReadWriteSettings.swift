//
//  MockReadWriteSettings.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation
@testable import PetrMazepa

class MockReadWriteSettings: ReadWriteSettings {
    
    var offlineMode: Bool = false
    var onlyWifiImages: Bool = false
}