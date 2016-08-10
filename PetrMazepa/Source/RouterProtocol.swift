//
//  RouterProtocol.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 5/6/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol RouterProtocol {
    
    func presentArticles()
    func presentArticleDetails(article: Article)
    func dismissArticleDetails()
    func presentSettings()
    func dismissSettings()
    func presentSearch()
    func dismissSearch()
    func shareArticle(article: Article)
    func openURL(url: NSURL)
}
