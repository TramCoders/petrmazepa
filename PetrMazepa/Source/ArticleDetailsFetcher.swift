//
//  ArticleDetailsFetcher.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/4/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

typealias ArticleDetailsFetchHandler = (ArticleDetails?, NSError?) -> ()

protocol ArticleDetailsFetcher {
    func fetchArticleDetails(article article: Article, completion: ArticleDetailsFetchHandler)
}
