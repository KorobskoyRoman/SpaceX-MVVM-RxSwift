//
//  Splash+Infrastructure.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.07.2023.
//

import RxCocoa

protocol SplashModuleType {
    var moduleBindings: SplashViewModel.ModuleBindings { get }
}

protocol SplashViewModelType {
    var bindings: SplashViewModel.Bindings { get }
    var commands: SplashViewModel.Commands { get}
}

extension SplashViewModel {

    struct ModuleBindings {
        let done = PublishRelay<Void>()
        var launches = BehaviorRelay<[LaunchInfo]>(value: [])
    }

    struct Bindings {
        var getLaunches = PublishRelay<Void>()
    }

    struct Commands {
        let viewDidAppear = PublishRelay<Void>()
        var moduleDidLoad = PublishRelay<Void>()
    }

    struct Dependencies {
        let networkingService: NetworkServiceType
        let storage: LaunchesStorageType
    }
}
