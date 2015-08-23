//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView?
    weak var layout: ArticlesViewLayout?
    @IBOutlet weak var searchTextField: UITextField!
    let cellReuseIdentifier = "ArticleCell"
    
    var model: ArticlesViewModel? {
        
        didSet {
            
            if let notNilModel = self.model {
                
                notNilModel.articlesInserted = { (range: Range<Int>) in
                    
                    let insertedIndexPaths = self.layout!.insertArticles(range.count)
                    
                    if range.startIndex == 0 {
                        self.collectionView!.reloadData()
                    } else {
                        self.collectionView!.insertItemsAtIndexPaths(insertedIndexPaths)
                    }
                }
            }
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        // a collection view layout data source
        self.layout = self.collectionView!.collectionViewLayout as? ArticlesViewLayout
        self.model!.loadIfNeeded()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model!.articles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        let image = self.model!.articles[indexPath.row]
        cell.update(image)
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard let notNilModel = self.model else {
            return
        }
        
        guard notNilModel.loading == false else {
            return
        }
        
        let beyondBottom = scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentSize.height
        
        if beyondBottom >= 0 {
            notNilModel.loadMore()
        }
    }
}

