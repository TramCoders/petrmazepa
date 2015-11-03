//
//  ViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/3/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class ViewModel {
    
    private(set) var viewIsPresented = false
    
    func viewWillAppear() {
        self.viewIsPresented = true
    }
    
    func viewWillDisappear() {
        self.viewIsPresented = false
    }
}