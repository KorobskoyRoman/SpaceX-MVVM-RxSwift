//
//  SplashViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import RxSwift
import RxCocoa
import RxReachability
import Reachability

protocol SplashViewModelType {
    var showError: ((String) -> Void)? { get set }
    var hasError: Bool { get set }
    func fetchLaunches()
    func push()
    func stopNotify()
}

final class SplashViewModel: SplashViewModelType {
    weak var coordinator: AppCoodrinator?

    var showError: ((String) -> Void)?
    var hasError: Bool = false

    private var launches = BehaviorRelay<[LaunchInfo]>(value: [])

    private let networkingService: NetworkServiceType
    private let storageManager: LaunchesStorageType
    private let bag = DisposeBag()
    private var reachability = try? Reachability()

    init(networkingService: NetworkServiceType,
         storage: LaunchesStorageType) {
        self.networkingService = networkingService
        self.storageManager = storage
        getLaunches()
        startNotify()
        bind()
    }

    private func startNotify() {
        try? reachability?.startNotifier()
    }

    func stopNotify() {
        reachability?.stopNotifier()
    }

    func fetchLaunches() {
        hasError = false
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
                self.hasError = true
                showError?(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }

    private func bind() {
        reachability?.rx.isReachable
            .subscribe (onNext: { isReachable in
                if !isReachable {
                    self.showError?(
                        ReachabilityError.unavailable.description + "\nВы можете нажать \"Повторить\" для повторной загрузки. \nПри нажатии \"Продолжить\" будут загружены ранее полученные данные."
                    )
                }
            })
            .disposed(by: bag)
    }

    func push() {
        coordinator?.performTransition(with: .perform(.main))
    }
}
