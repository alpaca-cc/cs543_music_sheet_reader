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
            if let pixelBuffer = box.pixelBufferGray(width: 28, height: 28) {
                // Make the prediction with Core ML
                if let pred_arr = try? model.prediction(image: pixelBuffer).output1 {
                    var max_index = 0
                    var max = pred_arr[0]
                    for i in 0..<pred_arr.shape[0].intValue {
                        if pred_arr[i].intValue > max.intValue {
                            max = pred_arr[i]
                            max_index = i
                        }
                    }
                    print(max_index)
                }
            }
        }
        return -1
    }
    
    func get_boxes(fromMeasure measure: UIImage) -> [UIImage]? {
        var res = [UIImage]()
        for i in 0..<6 {
            guard let measureBox = measure.cgImage?.cropping(to: .init(x: i*50, y: 0, width: 50, height: 100)) else {
                return nil
            }
            res.append(UIImage.init(cgImage: measureBox))
        }
        return res
    }
    func resize(image: UIImage, withSize newSize: CGSize) -> UIImage {
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
