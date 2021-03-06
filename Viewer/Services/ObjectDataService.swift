//
// Created by C Apple on 04/03/2021.
//

import Foundation
import CoreData
import Rasterizer

final class ObjectDataService {
    private let context: PersistenceContainer = PersistenceContainer.shared

    func fetchAll() -> [ObjectModel]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Object")
        let objects = try? (context.container.viewContext.fetch(fetchRequest) as! [Object])

        return objects?.map { (o: Object) -> ObjectModel in mapToModel(o) }
    }

    func fetchById(id: String) -> ObjectModel? {
        if let obj = fetchById(id) {
            return mapToModel(obj)
        }
        return nil
    }

    func store(model: ObjectModel) {
        if let obj = fetchById(model.id) {
            mapFromModel(model, obj)
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Object", in: context.container.viewContext)!
            let obj = Object(entity: entity, insertInto: context.container.viewContext)
            mapFromModel(model, obj)
        }
        context.saveContext()
    }

    func store(models: [ObjectModel]) {
        let ctx = context.container.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Object")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["id"]
        let ids = try? (ctx.fetch(fetchRequest) as? [[String:Any]])?
                .map { $0["id"] as! String }

        let idSet = Set<String>(ids ?? [])

        for model in models {
            let obj: Object
            if idSet.contains(model.id) {
                obj = fetchById(model.id)!
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Object", in: ctx)!
                obj = Object(entity: entity, insertInto: ctx)
            }
            mapFromModel(model, obj)
        }
        context.saveContext()
    }

    private func fetchById(_ id: String) -> Object? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Object")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return (try! context.container.viewContext.fetch(fetchRequest)).first as? Object
    }

    private func mapToModel(_ o: Object) -> ObjectModel {
        ObjectModel(
            o.id!, o.name!,
            (o.vertices as? [Vec3])?.map { Vector3(x: $0.x, y: $0.y, z: $0.z)} ?? [],
            (o.indices as? [Int32])?.compactMap(UInt32.init) ?? []
        )
    }

    private func mapFromModel(_ m: ObjectModel, _ o: Object) {
        o.name = m.name
        o.indices = m.indices?.compactMap(Int32.init) as NSArray?
        o.vertices = m.vertices?.map { Vec3($0.x, $0.y, $0.z) } as NSArray?
    }
}
