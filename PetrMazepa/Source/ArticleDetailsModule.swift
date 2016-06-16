//
//  ArticleDetailsModule.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 17/06/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

protocol IArticleDetailsView: class {
    
    func reloadImage()
    func reloadHtmlText()
    func updateFavouriteState(favourite: Bool)
    func updateBarsVisibility(visible: Bool)
    func showError(error: NSError?)
}

protocol IArticleDetailsViewModel: class {
    
    var barsVisibile: Bool { get }
    var image: UIImage? { get }
    var htmlText: String? { get }
    var topOffset: CGFloat { get }
    
    func viewDidLayoutSubviews(screenSize size: CGSize)
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func applicationWillResignActive()
    func backTapped()
    func favouriteTapped()
    func shareTapped()
    func closeActionTapped()
    func retryActionTapped()
    func scrollViewWillBeginDragging(offset offset: CGFloat)
    func scrollViewDidScroll(offset offset: CGFloat, contentHeight: CGFloat)
    func textDidLoad()
}
