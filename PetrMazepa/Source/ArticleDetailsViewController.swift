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
            self.model.favouriteStateChanged = self.favouriteStateChangedHandler()
            self.model.imageLoaded = self.imageLoadedHandler()
            self.model.articleDetailsLoaded = self.articleDetailsLoadedHandler()
            self.model.errorOccurred = self.errorOccurredHandler()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    private let components: [ArticleComponent]
    
    required init?(coder aDecoder: NSCoder) {
        
        let textComponent = ArticleTextComponent()
        self.components = [ ArticleImageComponent(), textComponent ]
        
        super.init(coder: aDecoder)
        textComponent.delegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .None
        
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
        self.model!.viewWillAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.model!.viewWillDisappear()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.model.viewDidAppear()
    }
    
    @IBAction func backTapped(sender: AnyObject) {
        self.model!.backTapped()
    }
    
    @IBAction func favouriteTapped(sender: UIButton) {
        self.model!.favouriteTapped()
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        self.model!.shareTapped()
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
    
    private func favouriteStateChangedHandler() -> ((favourite: Bool) -> Void) {
        return { favourite in
            
            let image = favourite ? UIImage(named: "favourite_icon") : UIImage(named: "unfavourite_icon")
            self.favouriteButton.setImage(image, forState: UIControlState.Normal)
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.favouriteButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: { _ in
                self.favouriteButton.transform = CGAffineTransformIdentity
            })
        }
    }
    
    private func imageLoadedHandler() -> ((image: UIImage?) -> Void) {
        return { image in
            
            let imageComponent = self.components[0] as! ArticleImageComponent
            imageComponent.image = image
            self.collectionView.reloadItemsAtIndexPaths([ NSIndexPath(forItem: 0, inSection: 0) ])
        }
    }
    
    private func articleDetailsLoadedHandler() -> ((htmlText: String?) -> Void) {
        return { htmlText in
            
            let textComponent = self.components[1] as! ArticleTextComponent
            textComponent.text = htmlText
            let textIndexPath = NSIndexPath(forItem: 1, inSection: 0)
            
            self.collectionView.reloadItemsAtIndexPaths([ textIndexPath ])
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func errorOccurredHandler() -> ((error: NSError?) -> Void) {
        return { _ in
            
            let alertController = UIAlertController(title: nil, message: "При получении статьи произошла ошибка", preferredStyle: .Alert)
            
            let closeAction = UIAlertAction(title: "Закрыть", style: .Cancel, handler: { _ in
                self.model!.closeActionTapped()
            })
            
            let retryAction = UIAlertAction(title: "Ещё раз", style: .Default, handler: { _ in
                self.model!.retryActionTapped()
            })
            
            alertController.addAction(closeAction)
            alertController.addAction(retryAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
