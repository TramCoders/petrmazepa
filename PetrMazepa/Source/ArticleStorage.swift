//
//  ArticleStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/3/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ArticleStorage {

    var lastReadArticle: ArticleCaption? { get }
    
    func allArticles() -> [ArticleCaption]
    func allArticlesCount() -> Int
    func updateArticles(articles: [ArticleCaption]) -> [ArticleCaption]
}
