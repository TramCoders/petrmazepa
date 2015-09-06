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
        self.accessoryType = .DisclosureIndicator
    }

    func update(thumbnail thumb: UIImage?, title: String?, author: String?) {
        
        self.thumbImageView.image = thumb
        self.titleLabel.text = title
        self.authorLabel.text = author
    }
}