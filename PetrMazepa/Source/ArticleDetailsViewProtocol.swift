//
//  ArticleDetailsViewProtocol.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 27/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Foundation

protocol ArticleDetailsViewProtocol: class {
    
    func reloadImage()
    func reloadHtmlText()
    func updateFavouriteState(favourite: Bool)
    func updateBarsVisibility(visible: Bool)
    func showError(error: NSError?)
}
