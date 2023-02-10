//
//  Persistence.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.02.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Launches")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static func save() {
        let context = PersistenceController.shared.container.viewContext

        guard context.hasChanges else { return }

        do {
            try context.save()
            print("saved success!")
        } catch {
            fatalError("""
                \(#file),\
                \(#function),\
                \(error.localizedDescription)
            """)
        }
    }
}
