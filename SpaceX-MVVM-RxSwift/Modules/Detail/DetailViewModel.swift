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
    var name: Observable<String?> { get }
    var date: Observable<String> { get }
//    var country: Observable<String> { get }
//    var cost: Observable<String> { get }
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

    private func getDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        return formatter.string(from: date)
    }

    private func getCost(_ cost: Int) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: cost)) ?? "n/a"
    }
}

extension DetailViewModel {
    var title: String {
        return launchInfo?.value.name ?? ""
    }

    var image: String {
        return rocketInfo?.value.flickrImages?.first ?? ""
    }

    var name: Observable<String?> {
        return Observable.just(launchInfo?.value.name)
    }

    var date: Observable<String> {
        return Observable.just(getDate(launchInfo?.value.dateUTC ?? .now))
    }

//    var country: Observable<String> {
//        return Observable.just(rocketInfo?.value.country ?? "n/a")
//    }
//
//    var cost: Observable<String> {
//        return Observable.just(getCost(rocketInfo?.value.costPerLaunch ?? 0))
//    }
}
