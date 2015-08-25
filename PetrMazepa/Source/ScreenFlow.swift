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
        showArticles()
    }
    
    func showArticles() {
        
        let viewController = storyboard.instantiateInitialViewController() as! ArticlesViewController
        viewController.model = ArticlesViewModel()
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()
    }
    
}