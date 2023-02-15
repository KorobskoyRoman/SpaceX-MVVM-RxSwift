//
//  SplashViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let viewModel: SplashViewModelType
    private let image: UIImageView = {
        return UIImageViewBuilder()
            .contentMode(.scaleAspectFit)
            .build()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        push()
    }

    init(viewModel: SplashViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SplashViewController {
    func setupView() {
        navigationController?.navigationBar.isHidden = true
        view.showLoading(yConstant: 100)
        image.image = UIImage(named: "SpaceX-Logo")
        view.addSubview(image)
        view.backgroundColor = .mainBackground()
        setConstraints()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension SplashViewController {
    func push() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.stopLoading()
            self.viewModel.push()
        }
    }
}
