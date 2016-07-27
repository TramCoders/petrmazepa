//
//  ArticlesViewProtocol.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol ArticlesViewProtocol {
    
    func refreshingStateChanged(refreshing refreshing: Bool)
    func loadingMoreStateChanged(loadingMore loadingMore: Bool)
    func noArticlesVisibilityChanged(visible visible: Bool)
    func articlesInserted(inRange range: Range<Int>)
    func allArticlesDeleted()
    func articlesUpdated(newCount newCount: Int)
    func lastReadArticleVisibilityChanged(toVisible visible: Bool, animated: Bool)
    func navigationBarVisibilityChanged(visible visible: Bool, animated: Bool)
    func loadingInOfflineModeFailed()
    func errorOccurred()
}