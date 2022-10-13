//
//  MainViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import RxSwift
import RxCocoa

protocol MainViewModelType {
    var launches: BehaviorRelay<[LaunchInfo]> { get set }
    var reload: (() -> Void)? { get set }
    func getLaunches()
    func launchAt(indexPath: IndexPath) -> LaunchInfo
    func push()
}

final class MainViewModel: MainViewModelType {
    weak var coordinator: AppCoodrinator?
    var launches: BehaviorRelay<[LaunchInfo]> = BehaviorRelay<[LaunchInfo]>(value: [])
    var reload: (() -> Void)?
    private lazy var fetchedLaunches = [LaunchInfo]()
    private let networkingService: NetworkService

    init(networkingService: NetworkService) {
        self.networkingService = networkingService
        self.getLaunches()
        reload?()
    }

    func getLaunches()  {
        networkingService.fetchLaunches { results in
            self.launches.accept(results)
            self.reload?()
        }
    }

    func launchAt(indexPath: IndexPath) -> LaunchInfo {
        return launches.value[indexPath.item]
    }

    func push() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.coordinator?.performTransition(with: .perform(.detail))
        }
    }
}
