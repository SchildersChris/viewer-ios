//
//  UIGraphicsView.swift
//  Viewer
//
//  Created by C Apple on 11/02/2021.
//

import SwiftUI
import UIKit
import Rasterizer

struct GraphicsView : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIGraphicsView {
        return UIGraphicsView()
    }
    
    func updateUIView(_ uiView: UIGraphicsView, context: Context) {
        uiView.setNeedsDisplay()
    }
}

class UIGraphicsView : UIImageView {
    init() {
        let vertices:[Vector3] = [
            Vector3(x: -0.5, y: -0.5, z: -0.5),
            Vector3(x: 0.5, y: -0.5, z: -0.5),
            Vector3(x: -0.5, y: 0.5, z: -0.5),
            Vector3(x: 0.5, y: 0.5, z: -0.5),
            Vector3(x: -0.5, y: 0.5, z: -1.5),
            Vector3(x: 0.5, y: 0.5, z: -1.5),
            Vector3(x: -0.5, y: -0.5, z: -1.5),
            Vector3(x: 0.5, y: -0.5, z: -1.5),
        ]
        let indices:[UInt32] = [
            1,0,0, 2,0,0, 3,0,0,
            3,0,0, 2,0,0, 4,0,0,
            3,0,0, 4,0,0, 5,0,0,
            5,0,0, 4,0,0, 6,0,0,
            5,0,0, 6,0,0, 7,0,0,
            7,0,0, 6,0,0, 8,0,0,
            7,0,0, 8,0,0, 1,0,0,
            1,0,0, 8,0,0, 2,0,0,
            2,0,0, 8,0,0, 4,0,0,
            4,0,0, 8,0,0, 6,0,0,
            7,0,0, 1,0,0, 5,0,0,
            5,0,0, 1,0,0, 3,0,0
        ]
        
        let numIndices: UInt32 = 12
        
        let width: Int = 100;
        let height: Int = 100;
        
        let count = width * height;
        
        do {
            let zBufferPtr = UnsafeMutablePointer<Float>.allocate(capacity: count)
            zBufferPtr.initialize(repeating: Float.greatestFiniteMagnitude, count: count)
            
            let rasterImagePtr = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
            rasterImagePtr.initialize(repeating: 0, count: count)

            defer {
                zBufferPtr.deinitialize(count: count)
                zBufferPtr.deallocate()
                
                rasterImagePtr.deinitialize(count: count)
                rasterImagePtr.deallocate()
            }
            rasterize(vertices, indices, numIndices, zBufferPtr, Int32(width), Int32(height), rasterImagePtr)
                        
            let img = UIImage(cgImage: CGImage(
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bitsPerPixel: 8,
                                bytesPerRow: width,
                                space: CGColorSpaceCreateDeviceGray(),
                                bitmapInfo: CGBitmapInfo.byteOrderMask,
                                provider: CGDataProvider(data: CFDataCreate(nil, rasterImagePtr, count))!,
                                decode: nil,
                                shouldInterpolate: true,
                                intent: CGColorRenderingIntent.defaultIntent)!)
            
            super.init(image: img)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
