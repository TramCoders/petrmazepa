//
//  ArticleCellModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/9/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

enum RoundedCorner {
    
    case None
    case TopLeft
    case TopRight
}

class ArticleCellModel {
    
    private let imageGateway: ImageGateway
    private let article: Article
    let roundedCorner: RoundedCorner
    private var imageHandler: ImageHandler?

    var title: String {
        return article.title
    }
    
    required init(article: Article, roundedCorner: RoundedCorner, imageGateway: ImageGateway) {

        self.article = article
        self.roundedCorner = roundedCorner
        self.imageGateway = imageGateway
    }
    
    func requestImage(size size: CGSize, completion: ImageHandler) {
        
        guard let url = self.article.thumbUrl else {
            
            completion(image: nil, error: nil, fromCache: true)
            return
        }
        
        self.imageHandler = completion
        
        self.imageGateway.requestImage(spec: ImageSpec(url: url, size: size)) { [weak self] image, error, fromCache in
            dispatch_async(dispatch_get_main_queue()) {
            
                if let notNilImageHandler = self?.imageHandler {

                    notNilImageHandler(image: image, error: error, fromCache: fromCache)
                    self?.imageHandler = nil
                }
            }
        }
    }
    
}