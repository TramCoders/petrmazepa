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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        // accessory type
        self.accessoryType = .DisclosureIndicator
        
        // corner radius
        self.thumbImageView.layer.cornerRadius = self.thumbImageView.frame.width / 2
        self.thumbImageView.layer.masksToBounds = true
    }

    func update(title title: String?, author: String?) {
        
        self.titleLabel.text = title
        self.authorLabel.text = author
    }
    
    func updateThumb(image: UIImage?) {
        self.thumbImageView.image = image
    }
}
