//
//  ObjectDetailViewModel.swift
//
//  Created by C Apple on 14/02/2021.
//

import SwiftUI

final class ObjectViewModel : ObservableObject {
    private let objectService: ObjectService = ObjectService()
    @Published private(set) var objects: [Object] = []

    func loadObjects() {
        objectService.loadObjects { objects in
            DispatchQueue.main.async {
                self.objects = objects
            }
        }
    }

    func loadObject(id: String) {
        objectService.loadObject(id: id) { o in
            DispatchQueue.main.async {
               let object = self.objects.first(where: {$0.id == id})
               object?.vertices = o.vertices
               object?.indices = o.indices
            }
        }
    }
}
