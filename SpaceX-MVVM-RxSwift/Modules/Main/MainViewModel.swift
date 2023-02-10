//
//  MainViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import RxSwift
import RxCocoa

protocol MainViewModelType {
    var launches: BehaviorRelay<[LaunchInfo]> { get }
    var reload: (() -> Void)? { get set }
    var filterFromLatest: BehaviorRelay<Bool> { get }
    var dbLaunches: BehaviorRelay<[LaunchesEntity]> { get }
    func getLaunches()
//    func launchAt(indexPath: IndexPath) -> LaunchInfo
    func launchAt(indexPath: IndexPath) -> LaunchesEntity
//    func push(launch: LaunchInfo)
    func push(launch: LaunchesEntity)
}

final class MainViewModel: MainViewModelType {
    weak var coordinator: AppCoodrinator?
    var launches: BehaviorRelay<[LaunchInfo]> = BehaviorRelay<[LaunchInfo]>(value: [])
    var reload: (() -> Void)?
    var filterFromLatest = BehaviorRelay<Bool>(value: true)
    var dbLaunches = BehaviorRelay<[LaunchesEntity]>(value: [])

    private let networkingService: NetworkServiceType
    private let bag = DisposeBag()
    private let storageManager: LaunchesStorageType

    init(networkingService: NetworkServiceType,
         storage: LaunchesStorageType) {
        self.networkingService = networkingService
        self.storageManager = storage
        self.bind()
    }

    func getLaunches() {
        do {
            let launchs = try networkingService.fetchLaunches()
            launchs.subscribe { [weak self] in
                guard let self else { return }
                self.launches.accept($0.element ?? [])
                //                self.reload?()
                do {
                    try self.storageManager.save(launches: self.launches)
                } catch {}
            }
            .disposed(by: bag)

//            try storageManager.save(launches: launches)
        } catch {
            print(error.localizedDescription)
        }

        getDbLaunches()
    }

    private func getDbLaunches() {
        dbLaunches = storageManager.getLaunches()
        self.reload?()
    }

//    func launchAt(indexPath: IndexPath) -> LaunchInfo {
//        return launches.value[indexPath.item]
//    }

    func launchAt(indexPath: IndexPath) -> LaunchesEntity {
        return dbLaunches.value[indexPath.item]
    }

//    func push(launch: LaunchInfo) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
//            do {
//                let _ = try self.networkingService.fetchRocket(id: launch.rocket ?? "")
//            } catch {
//                print(error)
//            }
//            self.coordinator?.performTransition(with: .perform(.detail(launch)))
//        }
//    }

    func push(launch: LaunchesEntity) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            do {
                let _ = try self.networkingService.fetchRocket(id: launch.rocket ?? "")
            } catch {
                print(error)
            }
            self.coordinator?.performTransition(with: .perform(.detail(launch)))
        }
    }

    private func bind() {
        filterFromLatest
            .skip(1)
            .subscribe { [weak self] event in
                guard let self,
                        let element = event.element else { return }
                let newArray = self.launches.value

                self.launches.accept(element ?
                                     newArray.sorted(by: { $0.dateUTC > $1.dateUTC }) :
                                        newArray.sorted(by: { $0.dateUTC < $1.dateUTC }))
                self.reload?()
            }
        .disposed(by: bag)
    }
}
