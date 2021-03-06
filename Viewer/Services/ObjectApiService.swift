//
// Created by C Apple on 02/03/2021.
//

import Foundation

class ObjectApiService {
    private let baseUrl = "https://viewer-app-api.herokuapp.com"

    func fetchAll(completion: @escaping ([ObjectModel]) -> ()) {
        guard let url = URL(string: baseUrl + "/objects") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([ObjectModel].self, from: data) {
                    completion(response)
                    return
                }
            }
        }
        task.resume()
    }

    func fetchById(id: String, completion: @escaping (ObjectModel) -> ()) {
        guard let url = URL(string: baseUrl + "/objects/\(id)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(ObjectModel.self, from: data) {
                    completion(response)
                    return
                }
            }
        }
        task.resume()
    }
}
