//
//  SettingsViewController.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 10/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var offlineModeSwitch: UISwitch!
    @IBOutlet weak var onlyWifiImagesSwitch: UISwitch!
    
    var model: SettingsViewModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Настройки"
        self.offlineModeSwitch.on = self.model.offlineMode
        self.onlyWifiImagesSwitch.on = self.model.onlyWifiImages
    }
    
    @IBAction func offlineModeChanged(sender: UISwitch) {
        self.model.didSwitchOfflineMode(enabled: sender.on)
    }
    
    @IBAction func onlyWifiImagesChanged(sender: UISwitch) {
        self.model.didSwitchOnlyWifiImages(enabled: sender.on)
    }
}