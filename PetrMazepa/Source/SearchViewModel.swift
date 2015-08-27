//
//  SearchViewModel.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 8/26/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

class SearchViewModel: ViewModel {
    
    func keyboardWillAppear() {
        self.screenFlow.expandSearch()
    }
    
    func keyboardWillDisappear() {
        self.screenFlow.collapseSearch()
    }
}