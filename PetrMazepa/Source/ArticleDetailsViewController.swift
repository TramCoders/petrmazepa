//
//  ArticleDetailsViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/1/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    private let components: [ArticleComponent] = [ ArticleImageComponent(image: UIImage(named: "shadowdragon")!), ArticleInfoComponent(info: ArticleInfo(dateString: "02.02.2020", author: "П. Мазепа")), ArticleTextComponent(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed efficitur rhoncus blandit. Curabitur blandit a mauris at volutpat. Morbi tristique posuere sapien sed viverra. Morbi volutpat urna risus, sed ultrices est rutrum ac. Quisque dapibus massa nisl, a placerat ipsum lacinia a. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Quisque sem elit, posuere et maximus at, bibendum vel nisl. Aliquam eu justo facilisis, faucibus arcu vitae, blandit arcu.\n\nFusce ut nunc rhoncus, consectetur turpis a, viverra lectus. Proin posuere faucibus arcu, a condimentum massa volutpat ut. Donec ut odio non mi ultricies vulputate. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In congue sapien at pretium gravida. Sed ut erat dignissim, eleifend mauris at, tincidunt lacus. Proin in sapien eu quam tincidunt fermentum. Quisque sodales viverra turpis, at gravida nulla pulvinar eu. Maecenas aliquam ipsum eget tellus luctus scelerisque. Quisque hendrerit risus felis, eget congue tellus eleifend at. Sed tristique, massa eget viverra auctor, purus diam rhoncus ex, at placerat libero est a lacus. Proin id ex urna. Maecenas dapibus ultrices nibh, a vehicula risus egestas non. Sed euismod, purus a sollicitudin rhoncus, odio quam vulputate metus, eu vulputate magna nulla eget ligula.") ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // layout
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0)
        }
        
        for component in self.components {
            self.collectionView.registerNib(component.cellNib(), forCellWithReuseIdentifier: component.cellIdentifier())
        }
    }
    
    @IBAction func backTapped(sender: AnyObject) {
        // TODO:
        self.dismissViewControllerAnimated(true, completion: nil)
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
}
