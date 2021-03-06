//
//  ImageCacheUtil.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 12/28/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ImageCacheUtil {
    
    var sizeInBytes: UInt64 { get }
    func clearCache()
}
