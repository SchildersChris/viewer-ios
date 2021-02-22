//
// Created by C Apple on 21/02/2021.
//

import SwiftUI
import UIKit
import Rasterizer

struct GraphicsViewController : UIViewControllerRepresentable {
    let width: Int
    let height: Int
    let object: ObjectModel
    var zoom: Binding<Float>

    init(_ width: Int, _ height: Int, _ object: ObjectModel, _ zoom: Binding<Float>) {
        self.width = width
        self.height = height
        self.object = object
        self.zoom = zoom
    }

    func makeUIViewController(
            context: UIViewControllerRepresentableContext<GraphicsViewController>
    ) -> UIGraphicsViewController  {
        UIGraphicsViewController(zoom, width, height, object.indices, object.vertices)
    }

    func updateUIViewController(
            _ uiViewController: UIGraphicsViewController,
            context: UIViewControllerRepresentableContext<GraphicsViewController>) {}
}

class UIGraphicsViewController : UIViewController, DisplayObserver {
    private var displayObservable: DisplayObservable?
    private var imageView: UIImageView?

    private let width: Int
    private let height: Int

    private let indices: [UInt32]
    private let vertices: [Vector3]

    private var zBuffer: Array<Float>
    private var rasterImage: CFMutableData

    private var rotation: Float
    private var zoom: Binding<Float>

    init(_ zoom: Binding<Float>, _ width: Int, _ height: Int, _ indices: [UInt32], _ vertices: [Vector3]) {
        self.width = width
        self.height = height
        let count = width * height

        self.indices = indices
        self.vertices = vertices

        let size = MemoryLayout<UInt8>.size * count
        rasterImage = CFDataCreateMutable(kCFAllocatorDefault, size)!
        CFDataSetLength(rasterImage, size)

        zBuffer = Array<Float>(repeating: Float.greatestFiniteMagnitude, count: count)

        rotation = 0
        self.zoom = zoom

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(cgImage: CGImage(
                width: width,
                height: height,
                bitsPerComponent: 8,
                bitsPerPixel: 8,
                bytesPerRow: width,
                space: CGColorSpaceCreateDeviceGray(),
                bitmapInfo: CGBitmapInfo(rawValue: 0),
                provider: CGDataProvider(data: rasterImage)!,
                decode: nil,
                shouldInterpolate: true,
                intent: CGColorRenderingIntent.defaultIntent)!))

        view.addSubview(imageView!)
        displayObservable = DisplayObservable(observer: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayObservable?.stop()
    }

    func update(_ deltaTime: CFTimeInterval) {
        rotation += 1 * Float(deltaTime)

        var matrix = Matrix4x4(
                p1: Vector4(x: cosf(rotation), y: sinf(rotation), z: 0, w: 0),
                p2: Vector4(x: -sinf(rotation), y: cosf(rotation), z: 0, w: 0),
                p3: Vector4(x: 0, y: 0, z: zoom.wrappedValue, w: 0),
                p4: Vector4(x: 0, y: 0, z: 0, w: 1))

        rasterize(
            vertices, indices,
            UInt32(indices.count),
            &matrix, &zBuffer,
            UInt32(width), UInt32(height),
            CFDataGetMutableBytePtr(rasterImage))

        imageView?.image = UIImage(cgImage: CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGBitmapInfo(rawValue: 0),
            provider: CGDataProvider(data: rasterImage)!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent)!)
    }
}