//
//  Detail+Infrastructure.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 14.07.2023.
//

import Foundation
import RxRelay

protocol DetailModuleType {
    var moduleBindings: DetailViewModel.ModuleBindings { get }
    var moduleCommands: DetailViewModel.ModuleCommands { get}
}

protocol DetailViewModelType {
    var bindings: DetailViewModel.Bindings { get }
    var commands: DetailViewModel.Commands { get }
}

extension DetailViewModel {

    struct ModuleBindings {
        let launch = BehaviorRelay<LaunchesEntity?>(value: nil)
        let loadRocketInfo = PublishRelay<Void>()
    }

    struct ModuleCommands {

    }

    struct Bindings {
        let launch = BehaviorRelay<LaunchesEntity?>(value: nil)
        let rocket = BehaviorRelay<Rocket?>(value: nil)
        let rocketDetail = BehaviorRelay<RocketDetail?>(value: nil)
        let title = BehaviorRelay<String?>(value: nil)
        let image = BehaviorRelay<String?>(value: nil)
    }

    struct Commands {
        let openYoutube = BehaviorRelay<String?>(value: nil)
        let openWiki = BehaviorRelay<String?>(value: nil)
    }

    struct Dependencies {
        let networkingService: NetworkServiceType
        let udService: UserDefaultsType
    }
}
