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
    private let networkingService: NetworkServiceType
    private let bag = DisposeBag()

    init(networkingService: NetworkServiceType) {
        self.networkingService = networkingService
        self.bind()
    }

    func getLaunches() {
        do {
            let launchs = try networkingService.fetchLaunches()
            launchs.subscribe { [weak self] in
                guard let self else { return }
                self.launches.accept($0.element ?? [])
                self.reload?()
            }
            .disposed(by: bag)
        } catch {
            print(error, NetworkingError.noData)
        }
    }

    func launchAt(indexPath: IndexPath) -> LaunchInfo {
        return launches.value[indexPath.item]
    }

    func push(launch: LaunchInfo) {
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
