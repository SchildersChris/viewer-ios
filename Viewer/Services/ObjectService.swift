//
// Created by C Apple on 02/03/2021.
//

import Foundation

class ObjectService {
    private let baseUrl = "https://viewer-app-api.herokuapp.com"

    func loadObjects(completion: @escaping ([ObjectInfoModel]) -> ()) {
        guard let url = URL(string: baseUrl + "/objects") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([ObjectInfoModel].self, from: data) {
                    completion(response)
                    return
                }
            }
        }
        task.resume()
    }

    func loadObject(id: String, completion: @escaping (ObjectDetailModel) -> ()) {
        guard let url = URL(string: baseUrl + "/objects/\(id)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(ObjectDetailModel.self, from: data) {
                    completion(response)
                    return
                }
            }
        }
        task.resume()
    }
}
