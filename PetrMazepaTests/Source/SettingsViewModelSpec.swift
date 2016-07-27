//
//  SettingsViewModelSpec.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 13/07/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Quick
import Nimble
@testable import PetrMazepa

class SettingsViewModelSpec: QuickSpec {

    var viewModel: SettingsViewModel!
    
    var view: MockSettingsView!
    var router: MockRouter!
    var readWriteSettings: MockReadWriteSettings!
    var imageCacheUtil: MockImageCacheUtil!
    var tracker: MockTracker!
    
    override func spec() {
        
        beforeEach {
            
            self.view = MockSettingsView()
            self.readWriteSettings = MockReadWriteSettings()
            self.router = MockRouter()
            self.imageCacheUtil = MockImageCacheUtil()
            self.tracker = MockTracker()
            
            self.viewModel = SettingsViewModel(view: self.view, settings: self.readWriteSettings, router: self.router, imageCacheUtil: self.imageCacheUtil, tracker: self.tracker)
        }
        
        describe("a user taps 'close' button on the settings screen") {
            it("closes the screen") {
                
                self.viewModel.closeTapped()
                expect(self.router.isSettingsDismissed).to(beTrue())
            }
        }
        
        describe("a user taps 'clear cache'") {
            it("sets cache size to zero") {
                
                self.viewModel.clearCacheTapped()
                expect(self.viewModel.imageCacheSize) == 0
            }
            
            it("tracks") {
                
                self.viewModel.clearCacheTapped()
                expect(self.tracker.isClearImagesTracked).to(beTrue())
            }
        }
        
        describe("a user turns on 'offline mode'") {
            it("changes 'offline mode' to true") {
                
                self.viewModel.didSwitchOfflineMode(enabled: true)
                expect(self.viewModel.offlineMode).to(beTrue())
            }
        }
        
        describe("a user turns off 'offline mode'") {
            it("changes 'offline mode' to false") {
                
                self.viewModel.didSwitchOfflineMode(enabled: false)
                expect(self.viewModel.offlineMode).to(beFalse())
            }
        }
    }

}
