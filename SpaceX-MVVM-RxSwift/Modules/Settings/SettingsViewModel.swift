//
//  SettingsViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 13.02.2023.
//

import RxCocoa
import RxSwift

final class SettingsViewModel: SettingsModuleType, SettingsViewModelType {

    // MARK: - Dependencies

    let dependencies: Dependencies

    // MARK: - Module infrastructure
    let moduleBindings = ModuleBindings()
    let moduleCommands = ModuleCommands()

    // MARK: - ViewModel infrastructure
    let bindings = Bindings()
    let commands = Commands()

    private let bag = DisposeBag()

    // MARK: - Configuration
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        configure(dependencies: dependencies)
        configure(moduleCommands: moduleCommands)
        configure(commands: commands)
        configure(bindings: bindings)
    }

    func configure(dependencies: Dependencies) {

    }

    func configure(moduleCommands: ModuleCommands) {
        moduleCommands.getData.bind(to: Binder(self) { target, _ in
            target.getUDStates()
        }).disposed(by: bag)
    }

    func configure(commands: Commands) {
        commands.updateHeightState.bind(to: Binder(self) { target, _ in
            target.updateHeightState()
        }).disposed(by: bag)
        commands.updateDiameterState.bind(to: Binder(self) { target, _ in
            target.updateDiameterState()
        }).disposed(by: bag)
        commands.updateMassState.bind(to: Binder(self) { target, _ in
            target.updateMassState()
        }).disposed(by: bag)
        commands.updateWeightState.bind(to: Binder(self) { target, _ in
            target.updateWeightState()
        }).disposed(by: bag)
    }

    func configure(bindings: Bindings) {

    }

    private func getUDStates() {
        bindings.height.accept(dependencies.udService.getObject(with: .height))
        bindings.diameter.accept(dependencies.udService.getObject(with: .diameter))
        bindings.mass.accept(dependencies.udService.getObject(with: .mass))
        bindings.weight.accept(dependencies.udService.getObject(with: .weight))
    }

    private func updateHeightState() {
        dependencies.udService.save(for: .height)
    }

    private func updateDiameterState() {
        dependencies.udService.save(for: .diameter)
    }

    private func updateMassState() {
        dependencies.udService.save(for: .mass)
    }

    private func updateWeightState() {
        dependencies.udService.save(for: .weight)
    }
}
