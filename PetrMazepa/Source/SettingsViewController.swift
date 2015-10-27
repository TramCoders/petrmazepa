//
//  SettingsViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var wifiImagesSwitch: UISwitch!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Настройки"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        // TODO: update settings
    }
    
    @IBAction func wifiImagesChanged(sender: AnyObject) {
        // TODO: propagate changes
    }
}