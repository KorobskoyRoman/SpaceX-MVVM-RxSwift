//
//  DetailViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import RxSwift
import RxCocoa

protocol DetailViewModelType {
    var launchInfo: BehaviorRelay<LaunchInfo>? { get set }
    var title: String { get }
    var image: String { get }
    var rocketInfo: BehaviorRelay<Rocket>? { get set }
    func getRocketInfo()
}

final class DetailViewModel: DetailViewModelType {
    var launchInfo: BehaviorRelay<LaunchInfo>?
    var rocketInfo: BehaviorRelay<Rocket>? = BehaviorRelay<Rocket>(value: .emptyRocket)
    private let networkSerivce: NetworkService

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

extension DetailViewModel {
    var title: String {
        return launchInfo?.value.name ?? ""
    }

    var image: String {
        return rocketInfo?.value.flickrImages?.first ?? ""
    }
}
