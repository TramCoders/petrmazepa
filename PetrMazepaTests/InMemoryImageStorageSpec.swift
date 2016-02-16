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
        
        var storage: InMemoryImageStorage!
        
        beforeEach {
            storage = InMemoryImageStorage()
        }
        
        describe("the storage loading works properly") {
            context("when an image is specified only with URL") {
                
                var image: UIImage!
                var imageSpec: ImageSpec!
                
                beforeEach {
                    
                    storage = InMemoryImageStorage()
                    image = self.imageNamed("chersonesus")
                    imageSpec = ImageSpec(url: NSURL(string: "http://test.petrimazepa.com/bundles/pim/images/thumbs/1.jpeg")!)
                    storage.saveImage(spec: imageSpec, image: image)
                }
                
                it("returns an image if exists") {

                    let returnedImage = storage.loadImage(spec: imageSpec)
                    expect(returnedImage) != nil
                }
                
                it("returns nil if doesn't exist") {

                    let anotherImageSpec = ImageSpec(url: NSURL(string: "http://test.petrimazepa.com/bundles/pim/images/thumbs/2.jpeg")!)
                    let returnedImage = storage.loadImage(spec: anotherImageSpec)
                    expect(returnedImage) == nil
                }
            }
        }
    }
    
    private func imageNamed(name: String) -> UIImage! {
        return UIImage(named: "chersonesus", inBundle: NSBundle(forClass: self.classForCoder), compatibleWithTraitCollection: nil)!
    }
}
