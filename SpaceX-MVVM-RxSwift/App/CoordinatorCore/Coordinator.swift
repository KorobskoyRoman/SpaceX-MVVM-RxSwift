//
//  Coordinator.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 07.07.2023.
//

import UIKit

class Coordinator<T: UIResponder>: Hashable {

    private let hash = UUID.init().hashValue
    private (set) var container: T
    private var childs: Set<AnyHashable> = []

    init(container: T) {
        self.container = container
    }

    func addChild(_ child: AnyHashable) {
        childs.insert(child)
    }

    func removeChild(_ child: AnyHashable) {
        childs.remove(child)
    }

    func removeAllChilds() {
        childs.removeAll()
    }

    func start() {
        assertionFailure("Coordinator must override start method")
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }

    static func == (lhs: Coordinator<T>, rhs: Coordinator<T>) -> Bool {
        lhs.hash == rhs.hash
    }
}
