//
//  HeaderView.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/22/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class HeaderView : UIView {
    
    @IBOutlet weak var label: UILabel!
    
    var text: String? {
        didSet {
            self.label.text = self.text
        }
    }
}