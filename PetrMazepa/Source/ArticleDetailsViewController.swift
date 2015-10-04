//
//  ArticleDetailsViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var model: ArticleDetailsViewModel? {
        didSet {
            if let notNilModel = self.model {
                
                notNilModel.loadingStateChanged = self.loadingStateChangedHandler()
                notNilModel.imageLoaded = self.imageLoadedHandler()
                notNilModel.articleDetailsLoaded = self.articleDetailsLoadedHandler()
                notNilModel.errorOccurred = self.errorOccurredHandler()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let components: [ArticleComponent] = [ ArticleImageComponent(), ArticleInfoComponent(), ArticleTextComponent() ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // layout
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0)
        }
        
        for component in self.components {
            self.collectionView.registerNib(component.cellNib(), forCellWithReuseIdentifier: component.cellIdentifier())
        }
        
        self.model!.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backTapped(sender: AnyObject) {
        self.model!.backTapped()
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        // TODO:
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.components.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let component = self.components[indexPath.row]
        return component.generateCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let component = self.components[indexPath.row]
        let height = component.requiredHeight()
        let width = self.view.frame.width
        return CGSizeMake(width, height)
    }
    
    private func loadingStateChangedHandler() -> ((loading: Bool) -> Void) {
        return { loading in
            // TODO:
        }
    }
    
    private func imageLoadedHandler() -> ((image: UIImage?) -> Void) {
        return { image in
            
            let imageComponent = self.components[0] as! ArticleImageComponent
            imageComponent.image = image
            self.collectionView.reloadItemsAtIndexPaths([ NSIndexPath(forItem: 0, inSection: 0) ])
        }
    }
    
    private func articleDetailsLoadedHandler() -> ((date: NSDate?, author: String?, htmlText: String?) -> Void) {
        return { date, author, htmlText in
            
            let infoComponent = self.components[1] as! ArticleInfoComponent
            let textComponent = self.components[2] as! ArticleTextComponent
            
            infoComponent.info = ArticleInfo(date: date, author: author)
            textComponent.text = htmlText
            
            self.collectionView.reloadItemsAtIndexPaths([ NSIndexPath(forItem: 1, inSection: 0), NSIndexPath(forItem: 2, inSection: 0) ])
        }
    }
    
    private func errorOccurredHandler() -> ((error: NSError) -> Void) {
        return { error in
            // TODO:
        }
    }
}
