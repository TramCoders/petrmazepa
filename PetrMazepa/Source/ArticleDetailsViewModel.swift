//
//  ArticleDetailsViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/2/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class ArticleDetailsViewModel {
    
    var loadingStateChanged: ((loading: Bool) -> Void)?
    var imageLoaded: ((image: UIImage?) -> Void)?
    var articleDetailsLoaded: ((dateString: String, author: String, text: String) -> Void)?
    var errorOccurred: ((error: NSError) -> Void)?
    
    func viewDidLoad() {
        
        self.imageLoaded!(image: nil)
        self.articleDetailsLoaded!(dateString: "", author: "", text: "")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            self.articleDetailsLoaded!(dateString: "01.01.2015", author: "P. Mazepa", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed efficitur rhoncus blandit. Curabitur blandit a mauris at volutpat. Morbi tristique posuere sapien sed viverra. Morbi volutpat urna risus, sed ultrices est rutrum ac. Quisque dapibus massa nisl, a placerat ipsum lacinia a. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Quisque sem elit, posuere et maximus at, bibendum vel nisl. Aliquam eu justo facilisis, faucibus arcu vitae, blandit arcu.\n\nFusce ut nunc rhoncus, consectetur turpis a, viverra lectus. Proin posuere faucibus arcu, a condimentum massa volutpat ut. Donec ut odio non mi ultricies vulputate. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In congue sapien at pretium gravida. Sed ut erat dignissim, eleifend mauris at, tincidunt lacus. Proin in sapien eu quam tincidunt fermentum. Quisque sodales viverra turpis, at gravida nulla pulvinar eu. Maecenas aliquam ipsum eget tellus luctus scelerisque. Quisque hendrerit risus felis, eget congue tellus eleifend at. Sed tristique, massa eget viverra auctor, purus diam rhoncus ex, at placerat libero est a lacus. Proin id ex urna. Maecenas dapibus ultrices nibh, a vehicula risus egestas non. Sed euismod, purus a sollicitudin rhoncus, odio quam vulputate metus, eu vulputate magna nulla eget ligula.")
        }
        
        let imageDelayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(imageDelayTime, dispatch_get_main_queue()) {
            
            self.imageLoaded!(image: UIImage(named: "freeman"))
        }
    }
}
