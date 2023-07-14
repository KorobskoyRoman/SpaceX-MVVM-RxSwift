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
import Foundation


final class MainViewModel: MainModuleType, MainViewModelType {

    var showError: ((String) -> Void)?
    var filterFromLatest = BehaviorRelay<Bool>(value: true)

    private let bag = DisposeBag()
    private var reachability = try? Reachability()

    // MARK: - Dependencies
    let dependencies: Dependencies

    // MARK: - Module infrastructure
    let moduleBindings = ModuleBindings()

    // MARK: - ViewModel infrastructure
    var bindings = Bindings()
    let commands = Commands()

    // MARK: - Configuration
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        configure(commands: commands)
        configure(bindings: bindings)
        configure(moduleBindings: moduleBindings)
    }

    func configure(commands: Commands) {
        commands.goToDetails.bind(to: moduleBindings.startDetails).disposed(by: bag)
    }

    private func configure(moduleBindings: ModuleBindings) {
        bindings.openDetails.bind(to: moduleBindings.startDetails).disposed(by: bag)
    }

    func configure(bindings: Bindings) {
        bindings.getLaunches.bind(to: Binder(self) { target, _ in
            target.getLaunches()
        }).disposed(by: bag)

        bindings.updateData.bind(to: Binder<Void>(self) { target, _ in
            target.getLaunches()
        }).disposed(by: bag)

        bindings.startNotify.bind(to: Binder<Void>(self) { target, _ in
            target.startNotify()
        }).disposed(by: bag)

        bindings.stopNotify.bind(to: Binder<Void>(self) { target, _ in
            target.stopNotify()
        }).disposed(by: bag)

        bind()
    }

    func getLaunches() {
        bindings.launches.accept(dependencies.storageService.getLaunches())
    }

//    func launchAt(indexPath: IndexPath) -> LaunchesEntity {
//        return dbLaunches.value[indexPath.item]
//    }

    func push(launch: LaunchesEntity) {
        DispatchQueue.main.async { [weak self] in
            Task {
                guard let self else { return }
                do {
                    let _ = try await self.dependencies.networkingService.fetchRocket(id: launch.rocket ?? "")
                } catch {
                    self.showError?(error.localizedDescription)
                    print(error)
                }
            }
        }
    }

    func pushToSettings() {
//        self.coordinator?.performTransition(with: .perform(.settings))
    }

    private func bind() {
        filterFromLatest
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe { [weak self] event in
                guard let self,
                      let element = event.element else { return }
                let newArray = self.bindings.launches.value

                self.bindings.launches.accept(
                    element ?
                    newArray.sorted(by: { $0.dateUTC ?? Date() > $1.dateUTC ?? Date() }) :
                        newArray.sorted(by: { $0.dateUTC ?? Date() < $1.dateUTC ?? Date() })
                )
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

    private func stopNotify() {
        reachability?.stopNotifier()
    }
}
