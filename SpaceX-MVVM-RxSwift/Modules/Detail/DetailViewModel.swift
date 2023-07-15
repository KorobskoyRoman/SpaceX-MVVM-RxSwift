//
//  DetailViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import RxSwift
import RxCocoa

final class DetailViewModel: DetailModuleType, DetailViewModelType {

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
        configure(moduleBindings: moduleBindings)
        configure(commands: commands)
        configure(bindings: bindings)
        getRocketDetails()
    }

    func configure(dependencies: Dependencies) {

    }

    func configure(moduleCommands: ModuleCommands) {

    }

    func configure(moduleBindings: ModuleBindings) {
        moduleBindings.launch.bind(to: bindings.launch).disposed(by: bag)
        moduleBindings.loadRocketInfo.bind(to: Binder(self) { target, _ in
            target.getRocketInfo()
        }).disposed(by: bag)
    }

    func configure(commands: Commands) {

    }

    func configure(bindings: Bindings) {
        bindings.launch.filterNil().subscribe(onNext: {
            bindings.title.accept($0.name)
        }).disposed(by: bag)

        bindings.rocket.filterNil().subscribe(onNext: {
            bindings.image.accept($0.flickrImages?.randomElement() ?? "")
        }).disposed(by: bag)

        bindings.rocket.bind(to: Binder(self) { target, _ in
            target.getRocketDetails()
        }).disposed(by: bag)
    }

    private func getRocketInfo() {
        Task {
            do {
                guard let id = bindings.launch.value?.rocket else { return }
                bindings.rocket.accept(try await dependencies.networkingService.fetchRocket(id: id))
            } catch {
                print(error)
            }
        }
    }

    private func getRocketDetails() {
        let height = dependencies.udService.getObject(with: .height) ?
        bindings.rocket.value?.height.meters ?? 0.0 :
        bindings.rocket.value?.height.feet ?? 0.0

        let diameter = dependencies.udService.getObject(with: .diameter) ?
        bindings.rocket.value?.diameter.meters ?? 0.0 :
        bindings.rocket.value?.diameter.feet ?? 0.0

        let mass = dependencies.udService.getObject(with: .mass) ?
        bindings.rocket.value?.mass.kg ?? 0.0 :
        bindings.rocket.value?.mass.lb ?? 0.0

        let weight = dependencies.udService.getObject(with: .weight) ?
        bindings.rocket.value?.payloadWeights.first?.kg ?? 0.0 :
        bindings.rocket.value?.payloadWeights.first?.lb ?? 0.0

        bindings.rocketDetail.accept(
            .init(
                height: height,
                diameter: diameter,
                mass: mass,
                weight: weight
            )
        )
    }
}
