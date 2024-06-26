//
//  CoreDataStack.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let container: NSPersistentContainer
    private let mainContext: NSManagedObjectContext
    private lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()
    private var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
    private let iconFetchRequest = FavoritesEntity.fetchRequest()
    private let imageFetchRequest = ImageEntity.fetchRequest()
    
    init(model: CDModel) {
        let container = NSPersistentContainer(name: "Iconfinder")
        self.container = container
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let url = URL(fileURLWithPath: documentsPath).appendingPathComponent("\(model.rawValue).sqlite")
        
        do {
            try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                        configurationName: nil,
                                                                        at: url,
                                                                        options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                                                        NSInferMappingModelAutomaticallyOption: true])
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
        
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.persistentStoreCoordinator = coordinator
        
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.persistentStoreCoordinator = coordinator
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextDidChange(notification:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave,
                                               object: self.backgroundContext)
    }
}

extension CoreDataStack: IconDataKeeper {
    
    func checkIcon(id: String) -> Bool {
        iconFetchRequest.predicate = .init(format: "id == '\(id)'")
        var favorites = [FavoritesEntity]()
        backgroundContext.performAndWait {
            let result = try? iconFetchRequest.execute()
            if let result = result {
                favorites = result
            }
        }
        let entityExists = !favorites.isEmpty
        return entityExists
    }

    func deleteAllIcons() {
        iconFetchRequest.predicate = nil
        backgroundContext.performAndWait {
            let favorites = try? iconFetchRequest.execute()
            favorites?.forEach {
                backgroundContext.delete($0)
            }
            try? backgroundContext.save()
        }
    }

    func deleteIcon(id: String) {
        iconFetchRequest.predicate = .init(format: "id == '\(id)'")
        backgroundContext.performAndWait {
            if let objectToDelete = try? iconFetchRequest.execute().first {
                backgroundContext.delete(objectToDelete)
            }
            try? backgroundContext.save()
        }
    }
    
    func addIconEntity(id: String, date: Date, tags: String, size: String, imageData: Data) {
        do {
            let count = try mainContext.count(for: iconFetchRequest)
            if count == 10 {
                deleteOldest()
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        mainContext.performAndWait {
            let entity = FavoritesEntity(context: mainContext)
            entity.id = id
            entity.date = date
            entity.tags = tags
            entity.size = size
            entity.date = date
            entity.imageData = imageData
            try? mainContext.save()
        }
    }
    
    private func deleteOldest() {
        let date = Date()
        iconFetchRequest.predicate = .init(format: "date == '\(date)'")
        backgroundContext.performAndWait {
            if let objectToDelete = try? iconFetchRequest.execute().last {
                backgroundContext.delete(objectToDelete)
            }
            try? backgroundContext.save()
        }
    }
}

extension CoreDataStack: ImageDataKeeper {
    
    func checkImage(id: String) -> Data? {
        imageFetchRequest.predicate = .init(format: "id == '\(id)'")
        var images = [ImageEntity]()
        backgroundContext.performAndWait {
            let result = try? imageFetchRequest.execute()
            if let result = result {
                images = result
            }
        }
        return images.first?.imageData
    }

    func deleteAllImages() {
        imageFetchRequest.predicate = nil
        backgroundContext.performAndWait {
            let images = try? imageFetchRequest.execute()
            images?.forEach {
                backgroundContext.delete($0)
            }
            try? backgroundContext.save()
        }
    }

    func deleteImage(id: String) {
        imageFetchRequest.predicate = .init(format: "id == '\(id)'")
        backgroundContext.performAndWait {
            if let objectToDelete = try? imageFetchRequest.execute().first {
                backgroundContext.delete(objectToDelete)
            }
            try? backgroundContext.save()
        }
    }
    
    func addImageEntity(id: String, imageData: Data) {
        mainContext.performAndWait {
            let entity = ImageEntity(context: mainContext)
            entity.id = id
            entity.imageData = imageData
            try? mainContext.save()
        }
    }
}

extension CoreDataStack {
    @objc func contextDidChange(notification: Notification) {
        coordinator.performAndWait {
            mainContext.performAndWait {
                mainContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
}

extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }

}
