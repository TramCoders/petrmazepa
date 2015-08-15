//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ArticlesDataSource {
    
    var model: ArticlesViewModel? {
        
        didSet {
            
            if let notNilModel = self.model {
                
                notNilModel.articlesChanged = { (fromIndex: Int) in
                 
                    let articlesCount = notNilModel.articles.count
                    var newIndexPaths = [NSIndexPath]()
                    
                    for index in fromIndex...(articlesCount - 1) {
                        newIndexPaths.append(NSIndexPath(forRow: index, inSection: 0))
                    }
                    
                    self.collectionView.insertItemsAtIndexPaths(newIndexPaths)
                }
            }
            
            if self.isViewLoaded() {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let cellReuseIdentifier = "ArticleCell"
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // register an article cell
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // a collection view layout data source
        let collectionViewLayout = self.collectionView.collectionViewLayout as! ArticlesViewLayout
        collectionViewLayout.dataSource = self
    }
    
    func articlesInArticlesViewLayout() -> Array<UIImage> {
        return self.model!.articles
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
        
        if let notNilModel = self.model  {
            if notNilModel.loading {
                return
            }
        }
        
        let beyondBottom = scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentSize.height
        
        if beyondBottom >= 0 {
            if let notNilModel = self.model {
                
                // TODO: show activity indicator
                
                notNilModel.loadMore({ () -> Void in
                    
                    // TODO: hide activity indicator
                })
            }
        }
    }
}

