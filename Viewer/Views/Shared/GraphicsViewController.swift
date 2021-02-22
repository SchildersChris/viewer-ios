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

    var translate: Binding<Vector3>
    var rotate: Binding<Bool>
  
    func makeUIViewController(
            context: UIViewControllerRepresentableContext<GraphicsViewController>
    ) -> UIGraphicsViewController  {
        UIGraphicsViewController(
            width, height,
            object.indices,
            object.vertices,
            translate, rotate)
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

    private var zBuffer: CFMutableData
    private var frameBuffer: CFMutableData

    private var rotation: Float
    
    private var translate: Binding<Vector3>
    private var rotate: Binding<Bool>

    init(_ width: Int, _ height: Int, _ indices: [UInt32], _ vertices: [Vector3], _ translate: Binding<Vector3>, _ rotate: Binding<Bool>) {
        self.width = width
        self.height = height
        let count = width * height

        self.indices = indices
        self.vertices = vertices

        let frameSize = MemoryLayout<UInt8>.size * count
        frameBuffer = CFDataCreateMutable(kCFAllocatorDefault, frameSize)!
        CFDataSetLength(frameBuffer, frameSize)

        let zBufferSize = MemoryLayout<Float>.size * count
        zBuffer = CFDataCreateMutable(kCFAllocatorDefault, zBufferSize)!
        CFDataSetLength(zBuffer, zBufferSize)

        rotation = 0
        self.translate = translate
        self.rotate = rotate

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
                provider: CGDataProvider(data: frameBuffer)!,
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
        if rotate.wrappedValue {
            rotation += 1 * Float(deltaTime)
        }
        
        let t = translate.wrappedValue
        var mat = Matrix4x4(
            p1: Vector4(x: cosf(rotation), y:0, z: sinf(rotation), w: 0),
            p2: Vector4(x: 0, y: 1, z: 0, w: 0),
            p3: Vector4(x: -sinf(rotation), y: 0, z: cosf(rotation), w: 0),
            p4: Vector4(x: t.x, y: t.y, z: t.z, w: 1))
        
        rasterize(
            vertices, indices,
            UInt32(indices.count),
            &mat,
            CFDataGetMutableBytePtr(zBuffer)
                .withMemoryRebound(to: Float.self, capacity: width * height) { ptr in ptr },
            CFDataGetMutableBytePtr(frameBuffer),
            UInt32(width), UInt32(height))

        imageView?.image = UIImage(cgImage: CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGBitmapInfo(rawValue: 0),
            provider: CGDataProvider(data: frameBuffer)!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent)!)
    }
}
