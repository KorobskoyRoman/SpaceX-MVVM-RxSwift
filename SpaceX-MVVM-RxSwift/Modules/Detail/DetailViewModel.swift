//
//  DetailViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import RxSwift
import RxCocoa

protocol DetailViewModelType {
    var title: String { get }
    var image: String { get }
    var launchInfo: BehaviorRelay<LaunchInfo>? { get set }
    var rocketInfo: BehaviorRelay<Rocket>? { get set }
    func getRocketInfo()
}

final class DetailViewModel: DetailViewModelType {
    var launchInfo: BehaviorRelay<LaunchInfo>?
    var rocketInfo: BehaviorRelay<Rocket>? = BehaviorRelay<Rocket>(value: .emptyRocket)
    private let networkSerivce: NetworkService

    var title: String {
        launchInfo?.value.name ?? "n/a"
    }

    var image: String {
        rocketInfo?.value.flickrImages?.randomElement() ?? ""
    }

    init(networkSerivce: NetworkService, launchInfo: BehaviorRelay<LaunchInfo>?) {
        self.networkSerivce = networkSerivce
        self.launchInfo = launchInfo
        getRocketInfo()
    }

    func getRocketInfo() {
        networkSerivce.fetchRocket(id: launchInfo?.value.rocket ?? "") { [weak self] rocket in
            guard let self else { return }
            self.rocketInfo?.accept(rocket)
        }
    }
}
