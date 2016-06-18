//
//  ArticlesModule.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 18/06/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

protocol IArticlesViewModel {
    
    var lastReadArticleViewModel: SimpleArticleCellModel? { get }
    var navigationBarVisible: Bool { get }
    var lastReadArticleVisible: Bool { get }
    var articlesCount: Int { get }
    
    func viewWillAppear()
    func viewWillDisappear()
    func viewDidLoad(screenSize size: CGSize)
    func settingsTapped()
    func searchTapped()
    func refreshTriggered()
    func lastReadArticleTapped()
    func switchOffActionTapped()
    func cancelActionTapped()
    func retryActionTapped()
    func articleTapped(index index: Int)
    func articleModel(index index: Int) -> ArticleCellModel
    func willBeginDragging(offset offset: CGFloat)
    func didScroll(contentOffset contentOffset: CGFloat, distanceToBottom: CGFloat)
}

protocol IArticlesView {
    
    func refreshingStateChanged(refreshing refreshing: Bool)
    func loadingMoreStateChanged(loadingMore loadingMore: Bool)
    func noArticlesVisibilityChanged(visible visible: Bool)
    func articlesInserted(range range: Range<Int>)
    func allArticlesDeleted()
    func articlesUpdated(newCount newCount: Int)
    func lastReadArticleVisibilityChanged(visible visible: Bool, animated: Bool)
    func navigationBarVisibilityChanged(visible visible: Bool, animated: Bool)
    func loadingInOfflineModeFailed()
    func errorOccurred()
}
