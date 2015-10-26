//
//  DefaultImageCache.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

extension ImageCache {
    
    class func defaultImageCache() -> Self {
        return self.init(inMemoryImageStorage: InMemoryImageStorage(), persistentImageStorage: PersistentImageStorage(), downloader: Networking())
    }
}
