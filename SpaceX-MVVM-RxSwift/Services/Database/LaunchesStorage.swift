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
    func getLaunches() -> [LaunchesEntity]
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
        DispatchQueue.global().async {
            launches
                .observe(on: MainScheduler.instance)
                .map {
                    $0.sorted(by: { $0.dateUTC > $1.dateUTC })
                }
                .subscribe { event in
                    guard let el = event.element else { return }
                    for var launch in el {
                        launch.toManagedObject(context: context)
                    }
                    do {
                        try context.save()
                        print("saved success!")
                    } catch {
                        print("fail to save into core data")
                    }
                }.disposed(by: bag)
        }
    }

    func getLaunches() -> [LaunchesEntity] {
        let fetchRequest = LaunchesEntity.fetchRequest()

        guard let results = try? context.fetch(fetchRequest),
              !results.isEmpty else {
            return []
        }
        return results
    }
}
