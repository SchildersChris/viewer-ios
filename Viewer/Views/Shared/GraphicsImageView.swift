//
//  UIGraphicsView.swift
//  Viewer
//
//  Created by C Apple on 11/02/2021.
//

import SwiftUI
import UIKit
import CoreGraphics
import Rasterizer

struct GraphicsImageView : UIViewRepresentable {
    let width: Int
    let height: Int
    let object: ObjectModel

    func makeUIView(context: Context) -> UIGraphicsImageView {
        UIGraphicsImageView(width, height, object.indices, object.vertices)
    }
    
    func updateUIView(_ uiView: UIGraphicsImageView, context: Context) {}
}

class UIGraphicsImageView : UIImageView {

    private let width: Int
    private let height: Int
    private let indices: [UInt32]
    private let vertices: [Vector3]

    private var zBuffer: Array<Float>
    private var rasterImage: Array<UInt8>
    private var matrix: Matrix4x4
    
    init(_ width: Int, _ height: Int, _ indices: Array<UInt32>, _ vertices: Array<Vector3>) {
        self.width = width
        self.height = height
        self.indices = indices
        self.vertices = vertices

        let count = width * height;

        rasterImage = Array<UInt8>(repeating: 0, count: width * height)
        zBuffer = Array<Float>(repeating: Float.greatestFiniteMagnitude, count: width * height)
        
        let angle: Float = 0.1
        matrix = Matrix4x4(
            p1: Vector4(x: cosf(angle), y: -sinf(angle), z: 0, w: 0),
            p2: Vector4(x: sinf(angle), y: cosf(angle), z: 0, w: 0),
            p3: Vector4(x: 0, y: 0, z: 1, w: 0),
            p4: Vector4(x: 0, y: 0, z: 0, w: 1)
        )
        
        /*
          This function will rasterize the provided vertices and indices into the provided raster image buffer.
          This buffer can then be used to draw into an image view.
         */
        rasterize(
            vertices, indices,
            UInt32(indices.count),
            &matrix, &zBuffer,
            UInt32(width), UInt32(height),
            &rasterImage
        )
    
        super.init(image: UIImage(
            cgImage: CGImage(
                width: width,
                height: height,
                bitsPerComponent: 8,
                bitsPerPixel: 8,
                bytesPerRow: width,
                space: CGColorSpaceCreateDeviceGray(),
                bitmapInfo: CGBitmapInfo(rawValue: 0),
                provider: CGDataProvider(data: CFDataCreate(nil, rasterImage, count))!,
                decode: nil,
                shouldInterpolate: true,
                intent: CGColorRenderingIntent.defaultIntent)!))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
