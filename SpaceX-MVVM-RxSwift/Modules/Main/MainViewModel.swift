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
    var reload: (()->Void)? { get set }
    func getLaunches()
    func launchAt(indexPath: IndexPath) -> Observable<LaunchInfo>
    func push()
}

final class MainViewModel: MainViewModelType {
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

    func launchAt(indexPath: IndexPath) -> Observable<LaunchInfo> {
        return Observable.just(launches.value[indexPath.item])
    }

    func push() {
        print(#function)
    }
}