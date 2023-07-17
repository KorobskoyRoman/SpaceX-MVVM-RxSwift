//
//  WebViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 18.02.2023.
//

import Foundation
import RxSwift

final class WebViewModel: WebModuleType, WebViewModelType {

    // MARK: - Module infrastructure
    let moduleBindings = ModuleBindings()
    let moduleCommands = ModuleCommands()

    // MARK: - ViewModel infrastructure
    var bindings = Bindings()
    let commands = Commands()

    private let bag = DisposeBag()

    // MARK: - Configuration
    init() {
        configure(commands: commands)
        configure(bindings: bindings)
        configure(moduleBindings: moduleBindings)
        configure(moduleCommands: moduleCommands)
    }

    func configure(commands: Commands) {

    }

    private func configure(moduleBindings: ModuleBindings) {
        moduleBindings.link.bind(to: bindings.downloadLink).disposed(by: bag)
    }

    private func configure(moduleCommands: ModuleCommands) {

    }

    func configure(bindings: Bindings) {

    }
}
