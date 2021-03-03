//
//  ObjectModel.swift
//  Viewer
//
//  Created by C Apple on 13/02/2021.
//

import Foundation
import Rasterizer

final class ObjectDetailModel: Decodable {
    let id: String
    let name: String
    let vertices: [Vector3]
    let indices: [UInt32]

    enum Keys: CodingKey {
        case _id
        case name
        case vertices
        case indices
    }

    init(_ id: String, _ name: String, _ vertices: [Vector3], _ indices: [UInt32]) {
        self.id = id
        self.name = name
        self.vertices = vertices
        self.indices = indices
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        vertices = try container.decode([Vector3].self, forKey: .vertices)
        indices = try container.decode([UInt32].self, forKey: .indices)
    }
}

extension Vector3: Decodable {
    enum Keys: CodingKey {
        case x
        case y
        case z
    }

    public init(from decoder: Decoder) {
        self.init()

        let container = try! decoder.container(keyedBy: Keys.self)
        x = try! container.decode(Float.self, forKey: .x)
        y = try! container.decode(Float.self, forKey: .y)
        z = try! container.decode(Float.self, forKey: .z)
    }
}
