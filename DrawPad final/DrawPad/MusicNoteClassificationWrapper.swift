//
//  MusicNoteClassification.swift
//  DrawPad
//
//  Created by Frank on 5/5/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreML
import UIKit
import CoreImage


@available(iOS 11.0, *)
class MusicNoteClassificationWrapper {
    var measureBox: UIImage?
    let model = MusicNoteClassification()
    func predictClass(img: UIImage) -> Int {
        guard let measureBox = img.cgImage?.cropping(to: .init(x: 90, y: 110, width: 300, height: 100)) else {
            return -1
        }
        self.measureBox = UIImage.init(cgImage: measureBox)
        
        guard let proposed_boxes = self.get_boxes(fromMeasure: self.measureBox!) else {
            return -1
        }
        for box in proposed_boxes {
            let resized_box = resize(image: box, withSize: .init(width: 28, height: 28))
            let predicted_class = try? model.prediction(image: buffer(from: resized_box)!)
        }
        return -1
    }
    
    func get_boxes(fromMeasure measure: UIImage) -> [UIImage]? {
        
        return [measure]
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        print(image.size)
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func resize(image: UIImage, withSize newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / image.size.width
        let verticalRatio = newSize.height / image.size.height
        
        var newImage: UIImage
        
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
        newImage = renderer.image {
            (context) in
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        }
        return newImage
    }

}
