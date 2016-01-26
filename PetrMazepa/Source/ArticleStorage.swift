//
//  ArticleStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/3/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ArticleStorage {

    var lastReadArticle: Article? { get }
    
    func allArticles() -> [Article]
    func allArticlesCount() -> Int
    func updateArticles(articles: [Article]) -> [Article]
}
