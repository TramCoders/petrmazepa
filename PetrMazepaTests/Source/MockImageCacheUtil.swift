//
//  MockImageCacheUtil.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation
@testable import PetrMazepa

class MockImageCacheUtil: ImageCacheUtil {
    
    private(set) var sizeInBytes: UInt64 = 10
    func clearCache() { sizeInBytes = 0 }
}