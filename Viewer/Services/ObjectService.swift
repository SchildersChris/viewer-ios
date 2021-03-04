//
// Created by C Apple on 02/03/2021.
//

import Foundation

class ObjectService {
    private let baseUrl = "https://viewer-app-api.herokuapp.com"
    private let context = PersistenceContainer.shared

    func loadObjects(completion: @escaping ([Object]) -> ()) {
        guard let url = URL(string: baseUrl + "/objects") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.userInfo[.managedObjectContext] = self.context.container.viewContext

                if let response = try? decoder.decode([Object].self, from: data) {
                    completion(response)
                    self.context.saveContext()
                    return
                }
            }
        }
        task.resume()
    }

    func loadObject(id: String, completion: @escaping (Object) -> ()) {
        guard let url = URL(string: baseUrl + "/objects/\(id)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.userInfo[.managedObjectContext] = self.context.container.viewContext

                if let response = try? decoder.decode(Object.self, from: data) {
                    completion(response)
                    self.context.saveContext()
                    return
                }
            }
        }
        task.resume()
    }
}
