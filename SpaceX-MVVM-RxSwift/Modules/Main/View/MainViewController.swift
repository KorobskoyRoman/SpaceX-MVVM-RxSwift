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
        NetworkService().fetchLaunches { result in
            print(result)
        }
        NetworkService().fetchRocket(id: "5e9d0d95eda69955f709d1eb") { result in
            print(result)
        }
    }

    private func setupView() {
        view.backgroundColor = .mainBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = MainConstants.mainTitle
    }
}

