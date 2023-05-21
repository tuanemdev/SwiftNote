//
//  PersistenceController.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 23/05/2023.
//

import CoreData

struct PersistenceController {
    static let shared: PersistenceController = .init()
    let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Item") /// Tên file .xcdatamodeld
        if inMemory { /// thường sử dụng cho mục đích test hoặc preview cho SwiftUI
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    /// Sử dụng để preview với SwiftUI
    static var preview: PersistenceController {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.name = "Macbook Air M2"
            newItem.price = Double(i) + 0.44
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }
}
