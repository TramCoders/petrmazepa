//
//  ArticlesViewModelProtocol.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

protocol ArticlesViewModelProtocol {
    
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