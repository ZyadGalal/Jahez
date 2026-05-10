//
//  CoreDataKeyValueStorage.swift
//  JahezData
//
//  Created by Zyad Galal on 09/05/2026.
//

import Foundation
import CoreData

public final class CoreDataKeyValueStorage: KeyValueStorage, @unchecked Sendable {

    private let modelName = "TMDBCache"
    private let entityName = "CachedEntry"
    private let keyAttribute = "key"
    private let valueAttribute = "value"

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init() {
        let model = Self.loadCompiledModel() ?? Self.makeProgrammaticModel(
            entityName: "CachedEntry",
            keyAttribute: "key",
            valueAttribute: "value"
        )
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error {
                NSLog("CoreDataKeyValueStorage failed to load store: %@", String(describing: error))
            }
        }

        context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    public func read<Value: Decodable>(
        _ type: Value.Type,
        forKey key: String
    ) async -> Value? {
        var result: Value?
        await context.perform { [weak self] in
            guard let self,
                  let entry = try? context.fetch(request(forKey: key)).first,
                  let data = entry.value(forKey: valueAttribute) as? Data else { return }
            result = try? decoder.decode(Value.self, from: data)
        }
        return result
    }

    public func write<Value: Encodable>(
        _ value: Value,
        forKey key: String
    ) async {
        await context.perform { [weak self] in
            guard let self,
                  let data = try? encoder.encode(value) else { return }
            let entry = (try? context.fetch(request(forKey: key)).first)
                ?? NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
            entry.setValue(key, forKey: keyAttribute)
            entry.setValue(data, forKey: valueAttribute)
            try? context.save()
        }
    }

    private func request(forKey key: String) -> NSFetchRequest<NSManagedObject> {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", keyAttribute, key)
        request.fetchLimit = 1
        return request
    }
}

// MARK: - Model loading

private extension CoreDataKeyValueStorage {
    static func loadCompiledModel() -> NSManagedObjectModel? {
        guard let url = Bundle.module.url(forResource: "TMDBCache", withExtension: "momd") else {
            return nil
        }
        return NSManagedObjectModel(contentsOf: url)
    }

    /// Mirror of the `.xcdatamodeld` schema, used as a fallback when the
    /// compiled model isn't present in the bundle.
    static func makeProgrammaticModel(
        entityName: String,
        keyAttribute: String,
        valueAttribute: String
    ) -> NSManagedObjectModel {
        let key = NSAttributeDescription()
        key.name = keyAttribute
        key.attributeType = .stringAttributeType
        key.isOptional = false

        let value = NSAttributeDescription()
        value.name = valueAttribute
        value.attributeType = .binaryDataAttributeType
        value.isOptional = false

        let entity = NSEntityDescription()
        entity.name = entityName
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        entity.properties = [key, value]

        let model = NSManagedObjectModel()
        model.entities = [entity]
        return model
    }
}
