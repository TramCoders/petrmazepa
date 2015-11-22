//
//  RemoteArticleDetailsFetcher.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

typealias ArticleDetailsFetchHandler = (ArticleDetails?, NSError?) -> ()

protocol RemoteArticleDetailsFetcher {
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler)
}