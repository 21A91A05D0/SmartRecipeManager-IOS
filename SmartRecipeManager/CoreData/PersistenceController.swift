//
//  PersistenceController.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import Foundation

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static let preview: PersistenceController = {
            let controller = PersistenceController(inMemory: true)
            return controller
        }()
        
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SmartRecipeManager")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
