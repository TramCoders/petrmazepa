//
//  FavouriteArticlesStorage.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/6/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol FavouriteArticlesStorage {
    func favouriteArticles() -> [Article]
}
