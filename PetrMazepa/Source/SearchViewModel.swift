//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

class SearchViewModel: ViewModel {
    
    func keyboardWillAppear(height height: CGFloat) {
        self.screenFlow.expandSearch(keyboardHeight: height)
    }
    
    func keyboardWillDisappear() {
        self.screenFlow.collapseSearch()
    }
}