//
//  ArticleDetailsLayout.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 12/3/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsLayout: UICollectionViewLayout  {
    
    private var attributes = [UICollectionViewLayoutAttributes]()
    private var imageAttrs: UICollectionViewLayoutAttributes!
    private var textAttrs: UICollectionViewLayoutAttributes!
    
    var imageCellHeight: CGFloat = 0.0
    var textCellHeight: CGFloat = 0.0
    
    override func prepareLayout() {
        
        if self.attributes.count == 0 {
            self.setupAttributes()
        }
        
        self.updateHeights()
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        var size = CGSizeZero
        
        for attrs in self.attributes {
            
            size.width = max(CGRectGetMaxX(attrs.frame), size.width)
            size.height = max(CGRectGetMaxY(attrs.frame), size.height)
        }
        
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
    
    private func setupAttributes() {

        self.setupImageAttrs()
        self.setupTextAttrs()
    }
    
    private func setupImageAttrs() {
        
        let imageIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.imageAttrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: imageIndexPath)
        self.imageAttrs.zIndex = -1
        self.attributes.append(self.imageAttrs)
    }
    
    private func setupTextAttrs() {
        
        let textIndexPath = NSIndexPath(forItem: 1, inSection: 0)
        self.textAttrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: textIndexPath)
        self.attributes.append(self.textAttrs)
    }
    
    private func updateHeights() {
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        self.imageAttrs.frame = CGRectMake(0.0, 0.0, screenWidth, self.imageCellHeight)
        self.textAttrs.frame = CGRectMake(0.0, self.imageCellHeight, screenWidth, self.textCellHeight)
    }
}
