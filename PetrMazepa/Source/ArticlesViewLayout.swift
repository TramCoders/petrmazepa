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
    private let verPadding: CGFloat = 2.0
    private let horPadding: CGFloat = 1.0
    private let margin: CGFloat = 1.0
    
    private var screenWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    private var cellWidth: CGFloat {
        return (self.screenWidth - 2 * self.horPadding - self.margin) / 2
    }
    
    func insertArticles(count: Int) {
        
        guard count > 0 else {
            return
        }

        let cellWidth = self.cellWidth
        let oldCount = self.attributes.count
        let insertedIndices = oldCount..<(oldCount + count)

        self.attributes.appendContentsOf(insertedIndices.map({ (index: Int) -> UICollectionViewLayoutAttributes in

            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

            let even = index % 2 == 0
            let left = (even ? self.horPadding : self.horPadding + cellWidth + self.margin)
            let top = self.verPadding + (cellWidth + self.margin) * CGFloat(index / 2)
            attrs.frame = CGRectMake(left, top, cellWidth, cellWidth)
            
            return attrs
        }))
    }
    
    func deleteAllArticles() {
        self.attributes.removeAll()
    }
    
    func showLoadingIndicator() {
        // TODO:
    }
    
    func hideLoadingIndicator() {
        // TODO:
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
        
        size.height += self.verPadding
        size.width += self.horPadding
        
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
