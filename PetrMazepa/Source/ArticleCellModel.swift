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

class ArticleCellModel : ImageCellModel {
    
    let roundedCorner: RoundedCorner
    
    var title: String {
        return self.article.title
    }
    
    init(settings: ReadOnlySettings, article: Article, roundedCorner: RoundedCorner, imageGateway: ImageGateway) {

        self.roundedCorner = roundedCorner
        super.init(settings: settings, article: article, imageGateway: imageGateway)
    }
}
