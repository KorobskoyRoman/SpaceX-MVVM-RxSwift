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
    var launchInfo: BehaviorRelay<LaunchInfo>? { get set }
    var rocketInfo: BehaviorRelay<Rocket>? { get set }
    func getRocketInfo()
}

final class DetailViewModel: DetailViewModelType {
    var launchInfo: BehaviorRelay<LaunchInfo>?
    var rocketInfo: BehaviorRelay<Rocket>? = BehaviorRelay<Rocket>(value: .emptyRocket)
    private let networkSerivce: NetworkServiceType

    var title: Observable<String> {
        return rocketInfo
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

    init(networkSerivce: NetworkServiceType, launchInfo: BehaviorRelay<LaunchInfo>?) {
        self.networkSerivce = networkSerivce
        self.launchInfo = launchInfo
        getRocketInfo()
    }

    func getRocketInfo() {
        do {
            guard let id = launchInfo?.value.rocket else { return }
            self.rocketInfo = try networkSerivce.fetchRocket(id: id)
        } catch {
            print(error)
        }
    }
}
