//
//  ArticlesViewLayout.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/7/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

protocol ArticlesDataSource {
    func articlesInArticlesViewLayout() -> Array<UIImage>
}

class ArticlesViewLayout: UICollectionViewLayout  {
    
    var dataSource: ArticlesDataSource?
    
    override func prepareLayout() {
        // TODO:
    }
    
    override func collectionViewContentSize() -> CGSize {

        // TODO:
        return CGSizeZero
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return []
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return nil
    }
    
}