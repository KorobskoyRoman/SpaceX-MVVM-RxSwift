//
//  RocketParamsCell.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 22.10.2022.
//

import UIKit

final class RocketParamsCell: UICollectionViewCell {
    static let reuseId = "RocketParamsCell"

    private let data: UILabel = {
        let label = UILabel()
        return label
    }()

    private let dataText: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 10
    }

    func configure(with param: Double) {
        data.text = "\(param)"
    }

    private func setConstraints() {
        contentView.addSubview(data)
        contentView.addSubview(dataText)

        NSLayoutConstraint.activate([
            data.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            data.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            data.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            dataText.topAnchor.constraint(equalTo: data.bottomAnchor, constant: 2),
            dataText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dataText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
