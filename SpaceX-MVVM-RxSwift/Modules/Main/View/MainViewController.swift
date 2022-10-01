//
//  MainViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import UIKit

final class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .mainBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = MainConstants.mainTitle
    }
}

