//
//  ToTopButton.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 05.02.2023.
//

import UIKit

final class ToTopButton: UIButton {
    var buttonIsHidden = true
    private let borderWidth: CGFloat = 1.0
    private let borderColor = UIColor.lightGray.cgColor

    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.up")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }

    private func setupView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.alpha = 0.0
        self.isHidden = true
    }

    private func setConstraints() {
        addSubview(image)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }

    func showButton(on view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0) {
//            self.center.x -= 100
            self.center.x -= view.bounds.width
            self.isHidden = false
            self.alpha = 1.0
        }
    }

    func hideButton(on view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.center.x += 100
            self.isHidden = true
            self.alpha = 0.0
        }
    }
}
