//
// Created by C Apple on 06/03/2021.
//

import Foundation
import Rasterizer
//
//@objc(Vector3ValueTransformer)
//public final class Vector3ValueTransformer : NSSecureUnarchiveFromDataTransformer {
//
//    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
//    static let name = NSValueTransformerName(rawValue: String(describing: Vector3ValueTransformer.self))
//
//    override public func transformedValue(_ value: Any?) -> Any? {
//        guard let vec = value as? Vec3 else { return nil }
//
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: vec, requiringSecureCoding: true)
//            return data
//        } catch {
//            assertionFailure("Failed to transform `Vec3` to `Data`")
//            return nil
//        }
//    }
//
//    override public func reverseTransformedValue(_ value: Any?) -> Any? {
//        guard let data = value as? NSData else { return nil }
//
//        do {
//            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: Vec3.self, from: data as Data)
//            return color
//        } catch {
//            assertionFailure("Failed to transform `Data` to `Vec3`")
//            return nil
//        }
//    }
//
//    // 2. Make sure `UIColor` is in the allowed class list.
//    public override static var allowedTopLevelClasses: [AnyClass] {
//        return [Vec3.self]
//    }
//
//    override public class func transformedValueClass() -> AnyClass {
//        Vec3.self
//    }
//
//    override public class func allowsReverseTransformation() -> Bool {
//        true
//    }
//}
//
//
//extension Vector3ValueTransformer {
//    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
//    static let name = NSValueTransformerName(rawValue: String(describing: Vector3ValueTransformer.self))
//
//    /// Registers the value transformer with `ValueTransformer`.
//    public static func register() {
//        let transformer = Vector3ValueTransformer()
//        ValueTransformer.setValueTransformer(transformer, forName: name)
//    }
//}