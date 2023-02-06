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
    func getLaunches()
    func launchAt(indexPath: IndexPath) -> LaunchInfo
    func push(launch: LaunchInfo)
}

final class MainViewModel: MainViewModelType {
    weak var coordinator: AppCoodrinator?
    var launches: BehaviorRelay<[LaunchInfo]> = BehaviorRelay<[LaunchInfo]>(value: [])
    var reload: (() -> Void)?
    var filterFromLatest = BehaviorRelay<Bool>(value: true)
    private let networkingService: NetworkService
    private let bag = DisposeBag()

    init(networkingService: NetworkService) {
        self.networkingService = networkingService
        self.getLaunches()
        self.bind()
    }

    func getLaunches()  {
        networkingService.fetchLaunches { results in
            self.launches.accept(results.sorted(by: {
                $0.dateUTC > $1.dateUTC
            }))
            self.reload?()
        }
    }

    func launchAt(indexPath: IndexPath) -> LaunchInfo {
        return launches.value[indexPath.item]
    }

    func push(launch: LaunchInfo) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.coordinator?.performTransition(with: .perform(.detail(launch)))
        }
    }

    private func bind() {
        filterFromLatest
            .skip(1)
            .subscribe { event in
                guard let element = event.element else { return }
                let newArray = self.launches.value
                if element {
                    self.launches = BehaviorRelay<[LaunchInfo]>(value: [])
                    self.launches.accept(newArray.sorted(by: {
                        $0.dateUTC > $1.dateUTC
                    }))
                    self.reload?()
                } else {
                    self.launches = BehaviorRelay<[LaunchInfo]>(value: [])
                    self.launches.accept(newArray.sorted(by: {
                        $0.dateUTC < $1.dateUTC
                    }))
                    self.reload?()
                }
            }
        .disposed(by: bag)
    }
}
