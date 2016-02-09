//
//  InMemoryImageStorageSpec.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 2/9/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

import Quick
import Nimble

class InMemoryImageStorageSpec: QuickSpec {
    override func spec() {

        describe("an in-memory image storage") {
            
            var storage: InMemoryImageStorage!
            beforeEach {
                storage = InMemoryImageStorage()
            }
            
            describe("test") {
                context("a test context") {
                    it("works perfectly") {
                        expect(1 + 1).to(equal(3))
                    }
                }
            }
        }
    }
}
