//
// Created by C Apple on 06/03/2021.
//

import Foundation

final class ObjectDetailViewModel : ObservableObject {
    private let apiService = ObjectApiService()
    private let dataService = ObjectDataService()

    @Published private(set) var object: ObjectModel

    init(object: ObjectModel) {
        self.object = object
    }

    func loadObject() {
        if let obj = dataService.fetchById(id: object.id) {
            object.vertices = obj.vertices
            object.indices = obj.indices
        }

        apiService.fetchById(id: object.id) { o in
            DispatchQueue.main.async { [self] in
                object.vertices = o.vertices
                object.indices = o.indices
                dataService.store(model: o)
            }
        }
    }
}
