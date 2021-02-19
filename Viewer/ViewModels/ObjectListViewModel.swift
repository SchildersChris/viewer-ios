//
//  ObjectDetailViewModel.swift
//  Viewer
//
//  Created by C Apple on 14/02/2021.
//

import Foundation
import SwiftUI

final class ObjectListViewModel: ObservableObject {
    let baseUrl = "https://viewer-app-api.herokuapp.com"

    @Published private(set) var objects: [ObjectModel] = []

    func loadObjects() {
        guard let url = URL(string: baseUrl + "/objects") else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([ObjectModel].self, from: data) {
                    DispatchQueue.main.async {
                        self.objects = response
                    }
                    return
                }
            }
        }.resume()
    }
}
