//
//  SplashViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private var viewModel: SplashViewModelType
    private let image: UIImageView = {
        return UIImageViewBuilder()
            .contentMode(.scaleAspectFit)
            .build()
    }()
    private lazy var animationContainer = InfoAlert()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        push()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopNotify()
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
        view.showLoading(yConstant: 200)
        image.image = R.image.spaceXLogo()

        animationContainer = InfoAlert(
            frame: CGRect(
                x: self.view.frame.minX,
                y: self.view.frame.minY,
                width: 300,
                height: 230
            )
        )

        animationContainer.center = view.center
        animationContainer.isHidden = true

        view.addSubview(image)
        view.addSubview(animationContainer)
        view.backgroundColor = .mainBackground()
        setConstraints()

        viewModel.showError = { [weak self] error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.animationContainer.infoLabel.text = error
            }
            self.animationContainer.actionCancel = {
                UIView.animate(withDuration: 0.3) {
                    self.animationContainer.alpha = 0.0
                    self.animationContainer.isHidden = true
                }
                self.viewModel.hasError = false
                self.push()
            }
            self.animationContainer.actionRetry = {
                UIView.animate(withDuration: 0.3) {
                    self.animationContainer.alpha = 0.0
                    self.animationContainer.isHidden = true
                }
                Task {
                    try? await Task.sleep(nanoseconds: 2_000_000)
                    self.viewModel.fetchLaunches()
                }
            }

            UIView.animate(withDuration: 1) {
                self.animationContainer.isHidden = false
                self.animationContainer.alpha = 1.0
            }
        }
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
        if !viewModel.hasError {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view.stopLoading()
                self.viewModel.push()
            }
        }
    }
}
