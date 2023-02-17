//
//  Launches+CoreData.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.02.2023.
//

import CoreData

extension LaunchInfo: UUIDIdentifiable {
    init(managedObject: LaunchesEntity) {
        self.id = managedObject.id ?? UUID()
        self.links = managedObject.linksValue
        self.rocket = managedObject.rocket
        self.success = managedObject.success
        self.details = managedObject.details
        self.name = managedObject.name
        self.dateUTC = managedObject.dateUTC ?? Date()
//        self.links.webcast = managedObject.webcastValue
    }

    private func checkForExistingLaunch(id: UUID, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Bool {
        let fetchRequest = LaunchesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name! as NSString) // вроде как 100%

        if let results = try? context.fetch(fetchRequest), results.first != nil {
            return true
        }
        return false
    }

    mutating func toManagedObject(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        guard checkForExistingLaunch(id: id, context: context) == false else { return }
        let persistedValue = LaunchesEntity.init(context: context)

        persistedValue.id = self.id
        persistedValue.links = self.links.patch.small
        persistedValue.rocket = self.rocket
        persistedValue.success = self.success ?? false
        persistedValue.details = self.details
        persistedValue.name = self.name
        persistedValue.dateUTC = self.dateUTC
        persistedValue.webcast = self.links.webcast
    }
}
