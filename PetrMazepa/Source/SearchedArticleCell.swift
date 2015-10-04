//
//  SearchedArticleCell.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/5/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchedArticleCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.accessoryType = .DisclosureIndicator
    }

    func update(title title: String?, author: String?) {
        
        self.titleLabel.text = title
        self.authorLabel.text = author
    }
    
    func updateThumb(image: UIImage?) {
        
        self.thumbImageView.image = image
        self.updateActivityIndicator(show: image == nil)
    }
    
    private func updateActivityIndicator(show show: Bool) {
        
        if show {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}