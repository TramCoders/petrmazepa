//
//  ArticlesViewLayout.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/7/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewLayout: UICollectionViewLayout  {
    
    private var attributes = [UICollectionViewLayoutAttributes]()
    private let topMargin: CGFloat = 2.0
    private let margin: CGFloat = 2.0
    private let internalMargin: CGFloat = 1.0
    
    func insertArticles(count: Int) -> [NSIndexPath] {
        
        guard count > 0 else {
            return []
        }

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let cellWidth = (screenWidth - 2 * self.margin - self.internalMargin) / 2

        let oldCount = self.attributes.count
        let insertedIndices = oldCount..<(oldCount + count)
        var insertedIndexPaths = [NSIndexPath]()

        self.attributes.appendContentsOf(insertedIndices.map({ (index: Int) -> UICollectionViewLayoutAttributes in

            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            insertedIndexPaths.append(indexPath)
            let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

            let even = index % 2 == 0
            let left = (even ? self.margin : self.margin + cellWidth + self.internalMargin)
            let top = self.topMargin + (cellWidth + self.internalMargin) * CGFloat(index / 2)
            attrs.frame = CGRectMake(left, top, cellWidth, cellWidth)
            
            return attrs
        }))
        
        return insertedIndexPaths
    }
    
    override func prepareLayout() {
        // do nothing
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
        return self.attributes.filter({ (attrs: UICollectionViewLayoutAttributes) -> Bool in
            return CGRectIntersectsRect(attrs.frame, rect)
        })
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributes[indexPath.row]
    }
}
