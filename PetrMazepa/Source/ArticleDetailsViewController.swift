//
//  ArticleDetailsViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ArticleTextComponentDelegate {
    
    var model: ArticleDetailsViewModel! {
        didSet {

            self.model.loadingStateChanged = self.loadingStateChangedHandler()
            self.model.imageLoaded = self.imageLoadedHandler()
            self.model.articleDetailsLoaded = self.articleDetailsLoadedHandler()
            self.model.errorOccurred = self.errorOccurredHandler()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let components: [ArticleComponent]
    
    required init?(coder aDecoder: NSCoder) {
        
        let textComponent = ArticleTextComponent()
        self.components = [ ArticleImageComponent(), ArticleInfoComponent(), textComponent ]
        
        super.init(coder: aDecoder)
        textComponent.delegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collectionView.scrollsToTop = true
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0)
        }
        
        for component in self.components {
            self.collectionView.registerNib(component.cellNib(), forCellWithReuseIdentifier: component.cellIdentifier())
        }
    }
    
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        self.model.viewDidLayoutSubviews(screenSize: UIScreen.mainScreen().bounds.size)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.model.viewDidAppear()
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
    
    func articleTextComponentDidDetermineHeight(sender component: ArticleTextComponent, height: CGFloat) {
        self.collectionView.collectionViewLayout.invalidateLayout()
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
    
    private func articleDetailsLoadedHandler() -> ((dateString: String?, author: String?, htmlText: String?) -> Void) {
        return { dateString, author, htmlText in
            
            let infoComponent = self.components[1] as! ArticleInfoComponent
            let textComponent = self.components[2] as! ArticleTextComponent
            
            infoComponent.info = ArticleInfo(dateString: dateString, author: author)
            textComponent.text = htmlText
            
            let infoIndexPath = NSIndexPath(forItem: 1, inSection: 0)
            let textIndexPath = NSIndexPath(forItem: 2, inSection: 0)
            
            self.collectionView.reloadItemsAtIndexPaths([ infoIndexPath, textIndexPath ])
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func errorOccurredHandler() -> ((error: NSError) -> Void) {
        return { error in
            // TODO:
        }
    }
}
