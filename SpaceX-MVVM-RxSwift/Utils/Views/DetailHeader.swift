//
//  DetailHeader.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.02.2023.
//

import UIKit

final class DetailHeader: UIView {
    private let imageView: ShimmerUIImageView = {
        let image = ShimmerUIImageView()
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: String) {
        imageView.startShimmerAnimation()
        imageView.sd_setImage(with: URL(string: image)) { [weak self] _,_,_,_ in
            guard let self else { return }
            guard self.imageView.image != nil else {
                return
            }
            self.imageView.removeShimmerAnimation()
        }
    }

    private func setConstraints() {
        addSubview(imageView)
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
