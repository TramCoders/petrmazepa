//
//  ImageDownloader.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 9/27/15.
//  Copyright © 2015 TramCoders. All rights reserved.
//

import Foundation

typealias ImageDownloadHandler = (NSData?, NSError?) -> ()

protocol ImageDownloader {
    func downloadImage(url: NSURL, completion: ImageDownloadHandler)
}
