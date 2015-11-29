//
//  ArticleDetailsFetcher.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/4/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

protocol ArticleDetailsFetcher : RemoteArticleDetailsFetcher {
    func fetchArticleDetails(article article: Article, allowRemote: Bool, completion: ArticleDetailsFetchHandler)
}
