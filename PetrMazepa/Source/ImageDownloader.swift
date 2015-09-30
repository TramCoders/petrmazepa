//
//  ImageDownloader.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

protocol ImageDownloader {
    func downloadImage(url: NSURL, completion: (NSData?, NSError?) -> ())
}
