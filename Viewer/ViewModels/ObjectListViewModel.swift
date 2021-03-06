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
        dataService.fetchAll { storeObjs in
            DispatchQueue.main.async { [self] in
                self.objects = storeObjs;

                apiService.fetchAll { apiObjs in
                    DispatchQueue.main.async { [self] in
                        objects = apiObjs
                        dataService.syncStore(models: apiObjs)
                    }
                }
            }
        }
    }
}
