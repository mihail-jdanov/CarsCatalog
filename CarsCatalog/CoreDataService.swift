//
//  CoreDataService.swift
//  CarsCatalog
//
//  Created by Михаил Жданов on 18.09.2020.
//

import Foundation
import CoreData

class CoreDataService {
    
    private static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CarsCatalog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    static func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func fetchObjects<T: NSManagedObject>(ofType type: T.Type) -> [T]? {
        let request = NSFetchRequest<T>(entityName: T.className)
        var objects: [T]?
        do {
            objects = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return objects
    }
        
    private init() {}
    
}
