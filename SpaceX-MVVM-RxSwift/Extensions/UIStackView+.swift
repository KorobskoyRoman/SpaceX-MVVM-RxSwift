//
//  UIStackView+.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 18.10.2022.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis,
                     spacing: CGFloat,
                     aligment: UIStackView.Alignment = .fill,
                     distribution: UIStackView.Distribution = .fill) {

        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = aligment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
