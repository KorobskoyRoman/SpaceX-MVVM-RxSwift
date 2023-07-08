//
//  DetailViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import RxSwift
import RxCocoa

protocol DetailViewModelType {
    var title: Observable<String> { get }
    var image: Observable<String> { get }
    var launchInfo: BehaviorRelay<LaunchesEntity>? { get set }
    var rocketInfo: BehaviorRelay<Rocket>? { get set }
    var height: Double { get }
    var diameter: Double { get }
    var mass: Double { get }
    var weight: Double { get }
    func getRocketInfo()
    func push(with url: String)
}

final class DetailViewModel: DetailViewModelType {
//    weak var coordinator: AppCoodrinator?
    var launchInfo: BehaviorRelay<LaunchesEntity>?
    var rocketInfo: BehaviorRelay<Rocket>? = BehaviorRelay<Rocket>(value: .emptyRocket)
    private let networkSerivce: NetworkServiceType
    private let udService: UserDefaultsType
    private let bag = DisposeBag()

    var title: Observable<String> {
        return launchInfo
            .map {
                $0.map {
                    $0.name ?? "n/a"
                }
            } ?? .just("n/a")
    }

    var image: Observable<String> {
        return rocketInfo.map {
            $0.map {
                $0.flickrImages?.randomElement() ?? ""
            }
        } ?? .just("")
    }

    init(
        networkSerivce: NetworkServiceType,
        launchInfo: BehaviorRelay<LaunchesEntity>?,
        udService: UserDefaultsType
    ) {
        self.networkSerivce = networkSerivce
        self.launchInfo = launchInfo
        self.udService = udService
        getRocketInfo()
    }

    func getRocketInfo() {
        Task {
            do {
                guard let id = launchInfo?.value.rocket else { return }
                self.rocketInfo = try await networkSerivce.fetchRocket(id: id)
            } catch {
                print(error)
            }
        }
    }

    func push(with url: String) {
//        coordinator?.performTransition(with: .perform(.web(url)))
    }
}

extension DetailViewModel {
    var height: Double {
        return udService.getObject(with: .height) ?
        rocketInfo?.value.height.meters ?? 0.0 :
        rocketInfo?.value.height.feet ?? 0.0
    }

    var diameter: Double {
        return udService.getObject(with: .diameter) ?
        rocketInfo?.value.diameter.meters ?? 0.0 :
        rocketInfo?.value.diameter.feet ?? 0.0
    }

    var mass: Double {
        return udService.getObject(with: .mass) ?
        rocketInfo?.value.mass.kg ?? 0.0 :
        rocketInfo?.value.mass.lb ?? 0.0
    }

    var weight: Double {
        return udService.getObject(with: .weight) ?
        rocketInfo?.value.payloadWeights.first?.kg ?? 0.0 :
        rocketInfo?.value.payloadWeights.first?.lb ?? 0.0
    }
}
