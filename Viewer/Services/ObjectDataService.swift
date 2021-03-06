//
// Created by C Apple on 04/03/2021.
//

import Foundation
import CoreData
import Rasterizer

final class ObjectDataService {
    private let context: PersistenceContainer = PersistenceContainer.shared

    func fetchAll(completion: @escaping ([ObjectModel]) -> ()) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Object")
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [self] asyncResult in
            completion((asyncResult.finalResult as? [Object])?.map { mapToModel($0) } ?? [])
        }

        try! context.container.viewContext.execute(asynchronousFetchRequest)
    }

    func fetchById(id: String, completion: @escaping (ObjectModel?) -> ()) {
        fetchById(id) { [self] obj in
            if let obj = obj {
                completion(mapToModel(obj))
            } else {
              completion(nil)
            }
        }
    }

    func store(model: ObjectModel) {
        fetchById(model.id) { [self] (object: Object?) in
            if let object = object {
                mapFromModel(model, object)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Object", in: context.container.viewContext)!
                let obj = Object(entity: entity, insertInto: context.container.viewContext)
                mapFromModel(model, obj)
            }
            context.saveContext()
        }
    }

    func syncStore(models: [ObjectModel]) {
        let ctx = context.container.viewContext

        for m in models {
            store(model: m)
        }

        let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Object")
        deleteRequest.predicate = NSPredicate(format: "not (id in %@)", argumentArray: [Set<String>(models.map { $0.id })])

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: deleteRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        try! ctx.execute(batchDeleteRequest)

        context.saveContext()
    }

    private func fetchById(_ id: String, completion: @escaping (Object?) -> ()) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Object")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asyncResult in
            completion((asyncResult.finalResult as? [Object])?.first)
        }

        try! context.container.viewContext.execute(asynchronousFetchRequest)
    }

    private func mapToModel(_ o: Object) -> ObjectModel {
        ObjectModel(
            o.id!, o.name!,
            (o.vertices as? [Vec3])?.map { Vector3(x: $0.x, y: $0.y, z: $0.z)} ?? [],
            (o.indices as? [Int32])?.compactMap(UInt32.init) ?? []
        )
    }

    private func mapFromModel(_ m: ObjectModel, _ o: Object) {
        o.id = m.id
        o.name = m.name

        if let indices = m.indices?.compactMap(Int32.init) as NSArray? {
            o.indices = indices
        }
        if let vertices = (m.vertices?.map { Vec3($0.x, $0.y, $0.z) }) as NSArray? {
            o.vertices = vertices
        }
    }
}
