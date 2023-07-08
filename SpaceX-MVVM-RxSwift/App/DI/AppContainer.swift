//
//  AppContainer.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import Swinject
import SwinjectAutoregistration

protocol DependencyProviderProtocol {
    func configure()
    func reset()
    func inject<T>() -> T
}

final class AppContainer: DependencyProviderProtocol {

    static let shared: DependencyProviderProtocol = AppContainer()

    let container = Container()

    init() {
        reset()
    }

    func inject<T>() -> T {
        if let service = container.resolve(T.self) {
            return service
        } else {
            fatalError("Dependency \(T.self) not injected")
        }
    }

    func configure() {
        registerUserDefaults()
        registerNetwork()
        registerDatabase()
    }

    func reset() {
        container.removeAll()
        configure()
    }
}
