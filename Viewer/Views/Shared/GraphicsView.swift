//
// Created by C Apple on 21/02/2021.
//

import SwiftUI
import UIKit
import Rasterizer

struct GraphicsView : UIViewRepresentable {
    var object: Binding<Object>
    let translate: Binding<(x: Float, y: Float, z: Float)>
    let rotate: Binding<Bool>

    func makeUIView(context: Context) -> UIGraphicsView  {
        UIGraphicsView(.zero, object, translate, rotate)
    }

    func updateUIView(_ uiView: UIGraphicsView, context: Context) {}
}

class UIGraphicsView : UIView, DisplayObserver {
    private let imageView: UIImageView
    private let object: Binding<Object>
    private let translate: Binding<(x: Float, y: Float, z: Float)>
    private let rotate: Binding<Bool>

    private var displayObservable: DisplayObservable?

    private var zBuffer: [Float]?
    private var frameBuffer: CFMutableData?
    private var width: Int
    private var height: Int
    private var rotation: Float

    init(_ frame: CGRect,
         _ object: Binding<Object>,
         _ translate: Binding<(x: Float, y: Float, z: Float)>,
         _ rotate: Binding<Bool>) {
        imageView = UIImageView()
        self.object = object
        self.translate = translate
        self.rotate = rotate

        width = 0
        height = 0
        rotation = 0

        super.init(frame: frame)

        displayObservable = DisplayObservable(observer: self)
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        if let display = displayObservable {
            display.stop()
        }
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

        if rotate.wrappedValue == true {
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
                ($object.wrappedValue.vertices as [Vector3], object.wrappedValue.indices,
            UInt32(object.wrappedValue.indices.count),
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
