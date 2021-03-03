//
// Created by C Apple on 03/03/2021.
//

import Foundation

final class ObjectInfoModel : Decodable {
    let id: String
    let name: String

    enum Keys: CodingKey {
        case _id
        case name
    }

    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
    }
}
