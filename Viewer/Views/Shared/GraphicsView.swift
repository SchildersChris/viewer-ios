//
// Created by C Apple on 21/02/2021.
//

import SwiftUI
import UIKit
import Rasterizer

struct GraphicsView : UIViewRepresentable {
    let object: ObjectModel
    let translate: Binding<(x: Float, y: Float, z: Float)>
    let rotate: Binding<Bool>

    func makeUIView(context: Context) -> UIGraphicsView  {
        UIGraphicsView(
            .zero,
            object.indices,
            object.vertices,
            translate, rotate)
    }

    func updateUIView(_ uiView: UIGraphicsView, context: Context) {}
}

class UIGraphicsView : UIView, DisplayObserver {
    private let imageView: UIImageView
    private var displayObservable: DisplayObservable?

    private let indices: [UInt32]
    private let vertices: [Vector3]

    private var zBuffer: [Float]?
    private var frameBuffer: CFMutableData?
    private var width: Int
    private var height: Int

    private var rotation: Float
    private let translate: Binding<(x: Float, y: Float, z: Float)>
    private let rotate: Binding<Bool>

    init(_ frame: CGRect,
         _ indices: [UInt32],
         _ vertices: [Vector3],
         _ translate: Binding<(x: Float, y: Float, z: Float)>,
         _ rotate: Binding<Bool>) {
        imageView = UIImageView()

        self.indices = indices
        self.vertices = vertices

        self.translate = translate
        self.rotate = rotate

        rotation = 0
        width = 0
        height = 0

        super.init(frame: frame)

        displayObservable = DisplayObservable(observer: self)
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        displayObservable?.stop()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = bounds
        width = Int(bounds.size.width)
        height = Int(bounds.size.height)

        let count = width * height
        let frameSize = MemoryLayout<UInt8>.size * count

        frameBuffer = CFDataCreateMutable(kCFAllocatorDefault, frameSize)!
        CFDataSetLength(frameBuffer, frameSize)
        zBuffer = Array<Float>(repeating: 0, count: count)
    }

    func update(_ deltaTime: CFTimeInterval) {
        guard width != 0 && height != 0 else { return }

        if rotate.wrappedValue {
            rotation += 1 * Float(deltaTime)
        }

        let t = translate.wrappedValue
        var mat = Matrix4x4(
            p1: Vector4(x: cosf(rotation), y:0, z: sinf(rotation), w: 0),
            p2: Vector4(x: 0, y: 1, z: 0, w: 0),
            p3: Vector4(x: -sinf(rotation), y: 0, z: cosf(rotation), w: 0),
            p4: Vector4(x: t.x, y: t.y, z: t.z, w: 1))

        let background: UInt8 = traitCollection.userInterfaceStyle == .light ? 255 : 0
        rasterize(
            vertices, indices,
            UInt32(indices.count),
            &mat, &zBuffer!,
            CFDataGetMutableBytePtr(frameBuffer!),
            background,
            UInt32(width), UInt32(height))

        draw()
    }

    private func draw() {
        imageView.image = UIImage(cgImage: CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGBitmapInfo(rawValue: 0),
            provider: CGDataProvider(data: frameBuffer!)!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent)!)
    }
}
