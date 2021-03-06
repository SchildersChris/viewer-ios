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
        dataService.fetchById(id: object.id) { obj in
            DispatchQueue.main.async { [self] in
                var usingCache = false
                if let obj = obj, obj.vertices?.count != 0 || obj.indices?.count != 0 {
                    object.vertices = obj.vertices
                    object.indices = obj.indices
                    usingCache = true
                }

                apiService.fetchById(id: object.id) { o in
                    DispatchQueue.main.async { [self] in
                        if !usingCache {
                            object.vertices = o.vertices
                            object.indices = o.indices
                        }
                        dataService.store(model: o)
                    }
                }
            }
        }
    }
}
