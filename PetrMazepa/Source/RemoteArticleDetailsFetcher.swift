//
//  RemoteArticleContentFetcher.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

typealias ArticleContentFetchHandler = (ArticleContent?, NSError?) -> ()

protocol RemoteArticleContentFetcher {
    func fetchArticleContent(forCaption caption: ArticleCaption, completion: ArticleContentFetchHandler)
}