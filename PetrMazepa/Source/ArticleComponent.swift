//
//  ArticleComponent.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

protocol ArticleComponentCell {
    func update(value: AnyObject?)
}

protocol ArticleComponent {
    
    func value() -> AnyObject?
    func cellIdentifier() -> String
    func cellNib() -> UINib
    func requiredHeight() -> CGFloat
    
    func generateCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell
}

extension ArticleComponent {
    
    func generateCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier(), forIndexPath: indexPath)
        
        if let componentCell = cell as? ArticleComponentCell {
            componentCell.update(self.value())
        }
        
        return cell
    }
}
