//
//  ViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ViewModel {
    
    var thumbImageLoaded: ((index: Int) -> Void)?
    let contentProvider: ContentProvider
    
    init(contentProvider: ContentProvider) {
        self.contentProvider = contentProvider
    }
    
    func requestThumb(index: Int) -> UIImage? {
        
        let completion = { (image: UIImage?, error: NSError?) in
            self.thumbImageLoaded!(index: index)
        }
        
        if let image = self.contentProvider.loadImage(index: index, completion: completion) {
            return image
        }
        
        return nil
    }
}