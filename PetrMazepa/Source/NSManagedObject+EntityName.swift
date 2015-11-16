//
//  NSManagedObject+EntityName.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/16/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class var entityName: String{
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}
