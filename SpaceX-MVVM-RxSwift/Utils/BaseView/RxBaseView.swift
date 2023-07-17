//
//  RxBaseView.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.07.2023.
//

import RxSwift

class RxBaseView: BaseView {

    // MARK: - Reactive

    var bag = DisposeBag()

    // MARK: - Lifecycle

    override func commonInit() {
        super.commonInit()
        setupBinding()
    }

    // MARK: - Settings

    func setupBinding() { }
}
