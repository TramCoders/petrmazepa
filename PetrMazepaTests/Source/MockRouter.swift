//
//  MockRouter.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation
@testable import PetrMazepa

class MockRouter: RouterProtocol {
    
    var isSettingsDismissed: Bool = false
    
    func presentArticles() {}
    func presentArticleDetails(article: Article) {}
    func dismissArticleDetails() {}
    func presentSettings() {}
    func dismissSettings() { isSettingsDismissed = true }
    func presentSearch() {}
    func dismissSearch() {}
    func shareArticle(article: Article) {}
}