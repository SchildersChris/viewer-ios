//
//  Object.swift
//  Viewer
//
//  Created by C Apple on 03/03/2021.
//

import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

class Object: NSManagedObject, Decodable {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var indices: [UInt32]
    @NSManaged var vertices: [Vector3]

    enum Keys: CodingKey {
        case _id
        case name
        case vertices
        case indices
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Object", in: context) else { fatalError() }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        vertices = try container.decode([Vector3].self, forKey: .vertices)
        indices = try container.decode([UInt32].self, forKey: .indices)
    }
}

class Vector3 : NSObject, Decodable {
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0

    required init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: Keys.self)
        x = try! container.decode(Float.self, forKey: .x)
        y = try! container.decode(Float.self, forKey: .y)
        z = try! container.decode(Float.self, forKey: .z)
    }

    enum Keys: CodingKey {
        case x
        case y
        case z
    }
}