//
//  AppContainer+BaseDependences.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import Swinject
import SwinjectAutoregistration

extension AppContainer {

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

    private func userDefaultsFactory() -> UserDefaultsService {
        UserDefaultsService.init()
    }

    private func databaseFactory() -> LaunchesStorage {
        LaunchesStorage(context: PersistenceController.shared.container.viewContext)
    }
}
