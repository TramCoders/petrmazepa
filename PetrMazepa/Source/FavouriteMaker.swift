//
//  FavouriteMaker.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/15/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol FavouriteMaker {
    func makeFavourite(article article: Article, details: ArticleDetails, favourite: Bool)
}
