//
//  RemoteArticlesFetcher.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

typealias ArticlesFetchHandler = (articles: [Article]?, error: NSError?) -> ()

protocol RemoteArticlesFetcher {
    func fetchArticles(fromIndex fromIndex: Int, count: Int, completion: ArticlesFetchHandler)
}