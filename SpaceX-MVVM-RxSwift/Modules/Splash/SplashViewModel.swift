//
//  SplashViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import RxSwift
import RxCocoa

protocol SplashViewModelType {
    func push()
}

final class SplashViewModel: SplashViewModelType {
    weak var coordinator: AppCoodrinator?

    private var launches = BehaviorRelay<[LaunchInfo]>(value: [])

    private let networkingService: NetworkServiceType
    private let storageManager: LaunchesStorageType
    private let bag = DisposeBag()

    init(networkingService: NetworkServiceType,
         storage: LaunchesStorageType) {
        self.networkingService = networkingService
        self.storageManager = storage
        getLaunches()
    }

    private func getLaunches() {
        Task {
            do {
                let launchs = try await networkingService.fetchLaunches()
                launchs
                    .observe(on: MainScheduler.instance)
                    .subscribe { [weak self] in
                        guard let self else { return }
                        self.launches.accept($0.element ?? [])
                    }
                    .disposed(by: bag)

                try storageManager.save(launches: launches)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func push() {
        coordinator?.performTransition(with: .perform(.main))
    }
}
