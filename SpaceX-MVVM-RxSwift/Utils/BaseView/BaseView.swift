//
//  BaseView.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.07.2023.
//

import UIKit

class BaseView: UIView {

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Settings

    func commonInit() {
        setupHierarchy()
        setupLayout()
        setupView()
    }

    func setupHierarchy() { }

    func setupLayout() { }

    func setupView() {
        backgroundColor = Color.backgroundColor
    }
}

fileprivate extension BaseView {
    enum Color {
        static let backgroundColor = UIColor.white
    }
}
