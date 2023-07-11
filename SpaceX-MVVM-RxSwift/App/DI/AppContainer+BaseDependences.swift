//
//  AppContainer+BaseDependences.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import Swinject
import SwinjectAutoregistration

extension AppContainer {

    // MARK: - Register dependecies

    func registerUserDefaults() {
        container.autoregister(
            UserDefaultsType.self,
            initializer: userDefaultsFactory
        ).inObjectScope(.container)
    }

    func registerNetwork() {
        container.autoregister(NetworkServiceType.self, initializer: NetworkService.init)
    }

    func registerDatabase() {
        container.autoregister(LaunchesStorageType.self, initializer: databaseFactory)
    }

    // MARK: - Private

    private func userDefaultsFactory() -> UserDefaultsService {
        UserDefaultsService.init()
    }

    private func databaseFactory() -> LaunchesStorage {
        LaunchesStorage(context: PersistenceController.shared.container.viewContext)
    }
}
