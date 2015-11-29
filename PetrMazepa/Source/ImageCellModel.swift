//
//  ImageCellModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/10/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ImageCellModel {
    
    private let imageGateway: ImageGateway
    private let settings: ReadOnlySettings
    let article: Article
    
    init(settings: ReadOnlySettings, article: Article, imageGateway: ImageGateway) {
        
        self.settings = settings
        self.article = article
        self.imageGateway = imageGateway
    }
    
    func requestImage(size size: CGSize, completion: ImageHandler) {
        
        guard let url = self.article.thumbUrl else {
            
            completion(image: nil, error: nil, fromCache: true)
            return
        }
        
        self.imageGateway.requestImage(spec: ImageSpec(url: url, size: size), allowRemote: !self.settings.offlineMode, onlyWifi: self.settings.onlyWifiImages) { [weak self] image, error, fromCache in
            dispatch_async(dispatch_get_main_queue()) {
                
                if let _ = self {
                    completion(image: image, error: error, fromCache: fromCache)
                }
            }
        }
    }
}
