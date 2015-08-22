//
//  ArticlesViewLayout.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/7/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

@objc protocol ArticlesDataSource {
    func articlesInArticlesViewLayout() -> Array<UIImage>
}

class ArticlesViewLayout: UICollectionViewLayout  {
    
    weak var dataSource: ArticlesDataSource?
    
    var attributes = Array<UICollectionViewLayoutAttributes>()
    let topMargin: CGFloat = 55.0
    let margin: CGFloat = 1.0
    let internalMargin: CGFloat = 1.0
    
    override func prepareLayout() {
        
        attributes.removeAll(keepCapacity: false)
        
        if let dataSource = self.dataSource {
            
            let screenWidth = UIScreen.mainScreen().bounds.size.width
            let cellWidth = (screenWidth - 2 * self.margin - self.internalMargin) / 2
            
            let articles = dataSource.articlesInArticlesViewLayout()
            var top = self.topMargin
            
            for var index = 0; index < articles.count; ++index {
                
                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                let even = index % 2 == 0
                let left = (even ? self.margin : self.margin + cellWidth + self.internalMargin)
                attrs.frame = CGRectMake(left, top, cellWidth, cellWidth)
                
                if !even {
                    top += cellWidth + self.internalMargin
                }
                
                attributes.append(attrs)
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {

        var size = CGSizeZero
        
        for attrs in self.attributes {
            
            size.width = max(CGRectGetMaxX(attrs.frame), size.width)
            size.height = max(CGRectGetMaxY(attrs.frame), size.height)
        }
        
        size.height += self.margin
        size.width += self.margin
        
        return size
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.row]
    }
    
}