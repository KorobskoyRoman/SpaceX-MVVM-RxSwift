//
//  LaunchesStorage.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 09.02.2023.
//

import CoreData
import RxRelay
import RxSwift

protocol LaunchesStorageType {
    func save(launches: BehaviorRelay<[LaunchInfo]>) throws
    func getLaunches() -> BehaviorRelay<[LaunchesEntity]>
}

struct LaunchesStorage {
    private let context: NSManagedObjectContext
    private let bag = DisposeBag()

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension LaunchesStorage: LaunchesStorageType {
    func save(launches: BehaviorRelay<[LaunchInfo]>) throws {
//        launches.subscribe { event in
//            guard let el = event.element else { return }
//            for var launch in el {
//                launch.toManagedObject(context: context)
//            }
//            do {
//                try context.save()
//                print("saved success!")
//            } catch {
//                print("fail to save into core data")
//            }
//        }.disposed(by: bag)
        let lnch = launches.value
        for var launch in lnch {
            launch.toManagedObject(context: context)
        }

        do {
            try context.save()
            print("saved success!")
        } catch {
            print("fail to save into core data")
        }
    }

    func getLaunches() -> BehaviorRelay<[LaunchesEntity]> {
        let fetchRequest = LaunchesEntity.fetchRequest()

        guard let results = try? context.fetch(fetchRequest),
              !results.isEmpty else {
            return BehaviorRelay<[LaunchesEntity]>(value: [])
        }
        return BehaviorRelay<[LaunchesEntity]>(value: results)
    }
}
