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
    @IBOutlet weak var imagesSizeLabel: UILabel!
    
    var model: SettingsViewModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Настройки"
        self.offlineModeSwitch.on = self.model.offlineMode
        self.onlyWifiImagesSwitch.on = self.model.onlyWifiImages
        self.updateImagesSize()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        self.model.closeTapped()
    }
    
    @IBAction func offlineModeChanged(sender: UISwitch) {
        self.model.didSwitchOfflineMode(enabled: sender.on)
    }
    
    @IBAction func onlyWifiImagesChanged(sender: UISwitch) {
        self.model.didSwitchOnlyWifiImages(enabled: sender.on)
    }
    
    @IBAction func clearImagesTapped(sender: AnyObject) {

        self.model.clearCacheTapped()
        self.updateImagesSize()
    }
    
    @IBAction func icon8Tapped(sender: AnyObject) {
        self.model.icon8Tapped()
    }
    
    private func updateImagesSize() {

        let size = Int64(self.model.imageCacheSize)
        let sizeString = NSByteCountFormatter.stringFromByteCount(size, countStyle: .File)
        self.imagesSizeLabel.text = sizeString
    }
}