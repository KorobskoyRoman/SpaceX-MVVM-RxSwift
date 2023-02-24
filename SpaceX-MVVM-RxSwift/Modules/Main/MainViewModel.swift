//
//  MainViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import RxSwift
import RxCocoa
import RxReachability
import Reachability

protocol MainViewModelType {
    var reload: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
    var filterFromLatest: BehaviorRelay<Bool> { get }
    var dbLaunches: BehaviorRelay<[LaunchesEntity]> { get }
    func getLaunches()
    func launchAt(indexPath: IndexPath) -> LaunchesEntity
    func push(launch: LaunchesEntity)
    func pushToSettings()
    func stopNotify()
}

final class MainViewModel: MainViewModelType {
    weak var coordinator: AppCoodrinator?
    var reload: (() -> Void)?
    var showError: ((String) -> Void)?
    var filterFromLatest = BehaviorRelay<Bool>(value: true)
    var dbLaunches = BehaviorRelay<[LaunchesEntity]>(value: [])

    private let networkingService: NetworkServiceType
    private let bag = DisposeBag()
    private let storageManager: LaunchesStorageType
    private var reachability = try? Reachability()

    init(networkingService: NetworkServiceType,
         storage: LaunchesStorageType) {
        self.networkingService = networkingService
        self.storageManager = storage
        self.bind()
        self.startNotify()
    }

    func getLaunches() {
        dbLaunches = storageManager.getLaunches()
        self.reload?()
    }

    func launchAt(indexPath: IndexPath) -> LaunchesEntity {
        return dbLaunches.value[indexPath.item]
    }

    func push(launch: LaunchesEntity) {
        DispatchQueue.main.async { [weak self] in
            Task {
                guard let self else { return }
                do {
                    let _ = try await self.networkingService.fetchRocket(id: launch.rocket ?? "")
                } catch {
                    self.showError?(error.localizedDescription)
                    print(error)
                }
                self.coordinator?.performTransition(with: .perform(.detail(launch)))
            }
        }
    }

    func pushToSettings() {
        self.coordinator?.performTransition(with: .perform(.settings))
    }

    private func bind() {
        filterFromLatest
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe { [weak self] event in
                guard let self,
                      let element = event.element else { return }
                let newArray = self.dbLaunches.value

                self.dbLaunches.accept(
                    element ?
                    newArray.sorted(by: { $0.dateUTC ?? Date() > $1.dateUTC ?? Date() }) :
                        newArray.sorted(by: { $0.dateUTC ?? Date() < $1.dateUTC ?? Date() })
                )

                self.reload?()
            }
            .disposed(by: bag)

        reachability?.rx.isReachable
            .subscribe (onNext: { isReachable in
                if !isReachable {
                    self.showError?(
                        ReachabilityError.unavailable.description
                    )
                }
            })
            .disposed(by: bag)

        reachability?.rx.reachabilityChanged
            .subscribe(onNext: { reachable in
            if reachable.connection != .unavailable {
                self.getLaunches()
            } else {
                self.showError?(
                    ReachabilityError.changedToUnavailable.description
                )
            }
        })
        .disposed(by: bag)
    }

    private func startNotify() {
        try? reachability?.startNotifier()
    }

    func stopNotify() {
        reachability?.stopNotifier()
    }
}
