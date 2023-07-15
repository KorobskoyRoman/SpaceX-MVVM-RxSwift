//
//  Main+Infrastructure.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 10.07.2023.
//

import Foundation
import RxCocoa

protocol MainModuleType {
    var moduleBindings: MainViewModel.ModuleBindings { get }
}

protocol MainViewModelType {
    var bindings: MainViewModel.Bindings { get }
    var commands: MainViewModel.Commands { get }
}

extension MainViewModel {

    struct ModuleBindings {
        let startDetails = BehaviorRelay<LaunchesEntity?>(value: nil)
        let startSettings = PublishRelay<Void>()
    }

    struct Bindings {
        let updateData = PublishRelay<Void>()
        let startNotify = PublishRelay<Void>()
        let stopNotify = PublishRelay<Void>()
        let openDetails = BehaviorRelay<LaunchesEntity?>(value: nil)
        var getLaunches = PublishRelay<Void>()
        var launches = BehaviorRelay<[LaunchesEntity]>(value: [])
    }

    struct ModuleCommands {

    }

    struct Commands {
        let goToDetails = BehaviorRelay<LaunchesEntity?>(value: nil)
        let openSettings = PublishRelay<Void>()
        let filterLaunches = PublishRelay<Void>()
    }

    struct Dependencies {
        let networkingService: NetworkServiceType
        let storageService: LaunchesStorageType
    }
}
