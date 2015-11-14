//
//  SearchedArticleCellModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/10/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class SearchedArticleCellModel : ImageCellModel {
    
    var title: String {
        return self.article.title
    }
}
