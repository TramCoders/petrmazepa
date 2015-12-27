//
//  ArticleStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/3/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ArticleStorage {

    func allArticles() -> [Article]
    func allArticlesCount() -> Int
}
