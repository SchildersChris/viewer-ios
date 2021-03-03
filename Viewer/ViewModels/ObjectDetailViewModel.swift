//
// Created by C Apple on 02/03/2021.
//

import SwiftUI

final class ObjectDetailViewModel: ObservableObject {
    @Published var object: ObjectDetailModel?

    private let objectService: ObjectService
    private let id: String

    init(id: String) {
        self.id = id
        objectService = ObjectService()
    }

    func loadObject() {
        objectService.loadObject(id: id) { object in
            DispatchQueue.main.async {
                self.object = object
            }
        }
    }
}
