//
//  ArticlesViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 7/19/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ArticlesDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let cellReuseIdentifier = "ArticleCell"
    
    let dummyArticles = [ UIImage(named: "chersonesus")!,
                          UIImage(named: "freeman")!,
                          UIImage(named: "hiroshima")!,
                          UIImage(named: "intermarium")!,
                          UIImage(named: "noyou")!,
                          UIImage(named: "pm-daily374")!,
                          UIImage(named: "pm-daily375")!,
                          UIImage(named: "putinkim")!,
                          UIImage(named: "shadowdragon")!,
                          UIImage(named: "vesti")! ]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: cellReuseIdentifier)
        
//        let collectionViewLayout = self.collectionView.collectionViewLayout as ArticlesViewLayout
//        collectionViewLayout.dataSource = self
    }
    
    func articlesInArticlesViewLayout() -> Array<UIImage> {
        return self.dummyArticles
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dummyArticles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as ArticleCell
        let image = self.dummyArticles[indexPath.row]
        cell.update(image)
        
        return cell
    }
    
}

