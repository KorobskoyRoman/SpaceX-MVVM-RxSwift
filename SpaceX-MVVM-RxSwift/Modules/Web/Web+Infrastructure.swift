//
//  Web+Infrastructure.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 15.07.2023.
//

import Foundation
import RxRelay

protocol WebModuleType {
    var moduleBindings: WebViewModel.ModuleBindings { get }
    var moduleCommands: WebViewModel.ModuleCommands { get}
}

protocol WebViewModelType {
    var bindings: WebViewModel.Bindings { get }
    var commands: WebViewModel.Commands { get }
}

extension WebViewModel {

    struct ModuleBindings {
        let link = BehaviorRelay<String?>(value: nil)
    }

    struct ModuleCommands {
        
    }

    struct Bindings {
        let downloadLink = BehaviorRelay<String?>(value: nil)
    }

    struct Commands {

    }
}
