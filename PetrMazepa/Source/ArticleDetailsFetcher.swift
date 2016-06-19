//
//  ArticleContentFetcher.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/4/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

protocol ArticleContentFetcher : RemoteArticleContentFetcher {
    func fetchArticleContent(forCaption caption: ArticleCaption, allowRemote: Bool, completion: ArticleContentFetchHandler)
}
