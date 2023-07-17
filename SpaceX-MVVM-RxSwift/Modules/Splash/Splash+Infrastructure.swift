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
        let startNotify = PublishRelay<Void>()
        let stopNotyfy = PublishRelay<Void>()
        let networkError = BehaviorRelay<String?>(value: nil)
        let hasError = PublishRelay<Bool>()
        var getLaunches = PublishRelay<Void>()
    }

    struct Commands {
        let viewDidAppear = PublishRelay<Void>()
        let showError = BehaviorRelay<String?>(value: nil)
    }

    struct Dependencies {
        let networkingService: NetworkServiceType
        let storage: LaunchesStorageType
    }
}
