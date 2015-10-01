//
//  ArticlesFetcher.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ArticlesFetcher {
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ([SimpleArticle]?, NSError?) -> ())
}
