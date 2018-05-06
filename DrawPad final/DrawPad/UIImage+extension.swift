//
//  UIImage+extension
//  DrawPad
//
//  Created by Frank on 5/5/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

extension UIImage {
    
    subscript (x: Int, y: Int) -> UIColor? {
        
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) {
            return nil
        }
        
        guard
            let provider = self.cgImage?.dataProvider,
            let providerData = provider.data,
            let data = CFDataGetBytePtr(providerData)
        else {
            return nil
        }
        
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        
        let r = CGFloat(data[pixelData]) / 255.0
        let g = CGFloat(data[pixelData + 1]) / 255.0
        let b = CGFloat(data[pixelData + 2]) / 255.0
        let a = CGFloat(data[pixelData + 3]) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}
