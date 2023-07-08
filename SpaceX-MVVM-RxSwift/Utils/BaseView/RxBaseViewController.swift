//
//  RxBaseViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.07.2023.
//

import RxSwift

class RxBaseViewController<V>: BaseViewController<V> where V: RxBaseView {

    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    func setupBinding() { }
}
