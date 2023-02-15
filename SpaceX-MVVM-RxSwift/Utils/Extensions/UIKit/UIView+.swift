//
//  UIView+.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 04.10.2022.
//

import UIKit

extension UIView {
    static let loadingViewTag = 1938123987
    static let labelInfoTag = 1938123988

    func showLoading(style: UIActivityIndicatorView.Style = .large,
                     color: UIColor? = nil,
                     text: String = ViewConstants.loadingText,
                     yConstant: CGFloat = 0) {
        DispatchQueue.main.async {
            var loading = self.viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
            if loading == nil {
                loading = UIActivityIndicatorView(style: style)
            }
            // label setup
            let infoLabel: UILabel = {
                let label = UILabel()
                label.text = text
                label.font = .systemFont(ofSize: 13, weight: .light)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()

            guard let loading = loading else { return }
            loading.translatesAutoresizingMaskIntoConstraints = false
            loading.startAnimating()
            loading.hidesWhenStopped = true
            loading.tag = UIView.loadingViewTag
            infoLabel.tag = UIView.labelInfoTag
            self.addSubview(loading)
            self.addSubview(infoLabel)
            loading.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: yConstant).isActive = true
            loading.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            infoLabel.centerYAnchor.constraint(equalTo: loading.centerYAnchor, constant: 25).isActive = true
            infoLabel.centerXAnchor.constraint(equalTo: loading.centerXAnchor).isActive = true

            if let color = color {
                loading.color = color
                infoLabel.textColor = color
            }
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            let loading = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            let infoLabel = self.viewWithTag(UIView.labelInfoTag) as? UILabel
            loading?.stopAnimating()
            loading?.removeFromSuperview()
            infoLabel?.removeFromSuperview()
        }
    }
}
