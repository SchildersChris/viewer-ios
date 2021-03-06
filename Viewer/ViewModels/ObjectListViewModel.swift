//
//  ObjectDetailViewModel.swift
//
//  Created by C Apple on 14/02/2021.
//

import SwiftUI

final class ObjectViewModel : ObservableObject {
    private let apiService = ObjectApiService()
    private let dataService = ObjectDataService()

    @Published private(set) var objects: [ObjectModel] = []

    func loadObjects() {
        if let objects = dataService.fetchAll() {
            self.objects = objects;
        }

        apiService.fetchAll { objs in
            DispatchQueue.main.async { [self] in
                objects = objs
                dataService.store(models: objs)
            }
        }
    }
}
