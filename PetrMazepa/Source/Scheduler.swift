//
//  Scheduler.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 3/29/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import UIKit

protocol FireCanceler {
    func cancel()
}

class Scheduler: NSObject, FireCanceler {
    
    static var pool = NSMutableSet()

    private var timer: NSTimer?
    private var block: () -> ()
    private var interval: NSTimeInterval
    
    class func fireBlock(after: NSTimeInterval, block: () -> ()) -> FireCanceler {
     
        let scheduler = Scheduler(block: block, interval: after)
        Scheduler.pool.addObject(scheduler)
        scheduler.schedule()
        return scheduler
    }
    
    func cancel() {
        
        if let timer = self.timer {
            
            timer.invalidate()
            self.removeFromPool()
        }
    }
    
    func fire() {
        
        self.block()
        self.removeFromPool()
    }
    
    private init(block: () -> (), interval: NSTimeInterval) {
        
        self.block = block
        self.interval = interval
    }
    
    private func schedule() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.interval, target: self, selector: Selector("fire"), userInfo: nil, repeats: false)
    }
    
    private func removeFromPool() {
        Scheduler.pool.removeObject(self)
    }
}
