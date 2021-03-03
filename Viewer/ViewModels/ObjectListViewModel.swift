//
//  ObjectDetailViewModel.swift
//  Viewer
//
//  Created by C Apple on 14/02/2021.
//

import SwiftUI

final class ObjectListViewModel: ObservableObject {
    private let objectService: ObjectService = ObjectService()
    @Published private(set) var objects: [ObjectInfoModel] = []

    func loadObjects() {
        objectService.loadObjects { objects in
            DispatchQueue.main.async {
                self.objects = objects
            }
        }
    }
}
