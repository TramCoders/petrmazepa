//
//  ScreenFlow.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/6/15.
//  Copyright (c) 2015 TramCoders. All rights reserved.
//

import UIKit

class ScreenFlow {
    
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func start() {
        
        let viewController = storyboard.instantiateInitialViewController() as UIViewController
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()
    }
    
    
}