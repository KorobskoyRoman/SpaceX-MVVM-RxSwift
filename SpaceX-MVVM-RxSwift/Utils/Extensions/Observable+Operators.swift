//
//  Observable+Operators.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.07.2023.
//

import RxSwift
import RxCocoa

protocol OptionalType {
    associatedtype Wrapped

    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension ObservableType where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }

    func replaceNilWith(_ nilValue: Element.Wrapped) -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .just(nilValue)
            }
        }
    }
}

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map({ _ in Void() })
    }

}

extension PrimitiveSequence where Trait == SingleTrait, Element: Any {

    func mapToVoid() -> Single<Void> {
        return map({ _ in Void() })
    }

}
