//
//  ArticleDetailsViewModelProtocol.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

protocol ArticleDetailsViewModelProtocol: class {
    
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
