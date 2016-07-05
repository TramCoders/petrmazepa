//
//  InMemoryImageStorageSpec.swift
//  PetrMazepa
//
//  Created by Artem Stepanenko on 2/9/16.
//  Copyright © 2016 TramCoders. All rights reserved.
//

//import Quick
//import Nimble
//
//class InMemoryImageStorageSpec: QuickSpec {
//    override func spec() {
//        
//        var storage: InMemoryImageStorage!
//        var image: UIImage!
//        var imageSpec: ImageSpec!
//        
//        beforeEach {
//            
//            storage = InMemoryImageStorage()
//            image = self.someImage()
//        }
//        
//        describe("a load method") {
//            context("when an image is specified only with a URL") {
//                beforeEach {
//                    
//                    imageSpec = ImageSpec(url: self.someUrl())
//                    storage.saveImage(withSpec: imageSpec, image: image)
//                }
//                
//                it("returns an image if exists") {
//
//                    let returnedImage = storage.loadImage(withSpec: imageSpec)
//                    expect(returnedImage).toNot(beNil())
//                }
//                
//                it("returns nil if doesn't exist") {
//
//                    let anotherImageSpec = ImageSpec(url: self.anotherUrl())
//                    let returnedImage = storage.loadImage(withSpec: anotherImageSpec)
//                    expect(returnedImage).to(beNil())
//                }
//            }
//            
//            context("when an image is specified with a URL and size") {
//                
//                var imageSpec: ImageSpec!
//                
//                beforeEach {
//                    
//                    imageSpec = ImageSpec(url: self.someUrl(), size: self.someSize())
//                    storage.saveImage(withSpec: imageSpec, image: image)
//                }
//                
//                it("returns an image if exists") {
//                    
//                    let returnedImage = storage.loadImage(withSpec: imageSpec)
//                    expect(returnedImage).toNot(beNil())
//                }
//                
//                it("returns nil if an existing image has a different size") {
//
//                    let anotherImageSpec = ImageSpec(url: self.someUrl(), size: self.anotherSize())
//                    let returnedImage = storage.loadImage(withSpec: anotherImageSpec)
//                    expect(returnedImage).to(beNil())
//                }
//                
//                it("returns nil if an existing image doesn't have a size") {
//                    
//                    let anotherImageSpec = ImageSpec(url: self.someUrl())
//                    let returnedImage = storage.loadImage(withSpec: anotherImageSpec)
//                    expect(returnedImage).to(beNil())
//                }
//            }
//        }
//        
//        describe("a clear method") {
//            beforeEach {
//                
//                imageSpec = ImageSpec(url: self.someUrl())
//                storage.saveImage(withSpec: imageSpec, image: image)
//            }
//            
//            it("removes all images") {
//                
//                storage.clear()
//                let returnedImage = storage.loadImage(withSpec: imageSpec)
//                expect(returnedImage).to(beNil())
//            }
//        }
//    }
//    
//    private func someImage() -> UIImage {
//        return UIImage(named: "chersonesus", inBundle: NSBundle(forClass: self.classForCoder), compatibleWithTraitCollection: nil)!
//    }
//    
//    private func someUrl() -> NSURL {
//        return NSURL(string: "http://test.petrimazepa.com/bundles/pim/images/thumbs/1.jpeg")!
//    }
//    
//    private func anotherUrl() -> NSURL {
//        return NSURL(string: "http://test.petrimazepa.com/bundles/pim/images/thumbs/2.jpeg")!
//    }
//    
//    private func someSize() -> CGSize {
//        return CGSizeMake(100.0, 100.0)
//    }
//    
//    private func anotherSize() -> CGSize {
//        return CGSizeMake(200.0, 200.0)
//    }
//}
