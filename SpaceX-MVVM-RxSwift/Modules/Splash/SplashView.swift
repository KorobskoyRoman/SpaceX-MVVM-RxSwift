//
//  SplashView.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.07.2023.
//

import UIKit
import RxSwift

final class SplashView: RxBaseView {

    private let image: UIImageView = {
        return UIImageViewBuilder()
            .contentMode(.scaleAspectFit)
            .build()
    }()

    private lazy var animationContainer = InfoAlert()

    override func setupView() {
        super.setupView()

        showLoading(yConstant: 200)
        image.image = R.image.spaceXLogo()

        animationContainer = InfoAlert(
            frame: CGRect(
                x: frame.minX,
                y: frame.minY,
                width: 300,
                height: 230
            )
        )

        animationContainer.center = self.center
        animationContainer.isHidden = true

        backgroundColor = .mainBackground()
    }

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(image)
        addSubview(animationContainer)
    }

    override func setupLayout() {
        super.setupLayout()
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
