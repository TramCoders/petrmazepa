//
//  ArticleCellModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/9/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleCellModel : ImageCellModel {
    
    var title: String {
        return self.article.title
    }
    
    var saved: Bool {
        return self.article.saved
    }
    
    var favorite: Bool {
        return self.article.favourite
    }
}
