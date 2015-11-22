//
//  ImageGateway.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 11/9/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import UIKit

typealias ImageHandler = (image: UIImage?, error: NSError?, fromCache: Bool) -> ()

protocol ImageGateway {
    
    func requestImage(spec spec: ImageSpec, completion: ImageHandler)
    func requestImage(spec spec: ImageSpec, allowWeb: Bool, completion: ImageHandler)
}
