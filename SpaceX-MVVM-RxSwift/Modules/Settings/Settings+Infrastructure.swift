//
//  Settings+Infrastructure.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 15.07.2023.
//

import Foundation
import RxRelay

protocol SettingsModuleType {
    var moduleBindings: SettingsViewModel.ModuleBindings { get }
    var moduleCommands: SettingsViewModel.ModuleCommands { get}
}

protocol SettingsViewModelType {
    var bindings: SettingsViewModel.Bindings { get }
    var commands: SettingsViewModel.Commands { get }
}

extension SettingsViewModel {

    struct ModuleBindings {
        
    }

    struct ModuleCommands {
        let getData = PublishRelay<Void>()
    }

    struct Bindings {
        let height = BehaviorRelay<Bool>(value: false)
        let diameter = BehaviorRelay<Bool>(value: false)
        let mass = BehaviorRelay<Bool>(value: false)
        let weight = BehaviorRelay<Bool>(value: false)
    }

    struct Commands {
        let updateHeightState = PublishRelay<Void>()
        let updateDiameterState = PublishRelay<Void>()
        let updateMassState = PublishRelay<Void>()
        let updateWeightState = PublishRelay<Void>()
    }

    struct Dependencies {
        let udService: UserDefaultsType
    }
}
