//
// Created by C Apple on 06/03/2021.
//

import CoreData

public class Vec3 : NSObject, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding = true

    let x: Float
    let y: Float
    let z: Float

    init (_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }

    enum Keys: String {
        case x = "x"
        case y = "y"
        case z = "z"
    }

    public func encode(with coder: NSCoder) {
        coder.encode(x, forKey: Keys.x.rawValue)
        coder.encode(y, forKey: Keys.y.rawValue)
        coder.encode(z, forKey: Keys.z.rawValue)
    }

    public required init?(coder: NSCoder) {
        x = coder.decodeFloat(forKey: Keys.x.rawValue)
        y = coder.decodeFloat(forKey: Keys.y.rawValue)
        z = coder.decodeFloat(forKey: Keys.z.rawValue)
    }
}