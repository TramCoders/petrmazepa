//
//  ReadWriteSettings.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ReadWriteSettings: class {

    var offlineMode: Bool { get set }
    var onlyWifiImages: Bool { get set }
}
