//
//  DetailCollectionCell.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.02.2023.
//

import UIKit

final class DetailCollectionCell: UICollectionViewCell {
    static let reuseId = "DetailCollectionCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stack = UIStackView(
        arrangedSubviews: [nameLabel, valueLabel],
        axis: .vertical,
        spacing: 30,
        aligment: .center,
        distribution: .equalCentering
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.height / 10
        backgroundColor = .mainBackground().withAlphaComponent(0.6)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with type: CellType, value: Double?) {
        nameLabel.text = type.rawValue

        guard let value else { return }
        valueLabel.text = String(value)
    }

    private func setConstraints() {
        let constTD: CGFloat = 20
        let constLT: CGFloat = 10

        addSubview(stack)
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: constTD),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constLT),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constLT),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension DetailCollectionCell {
    enum CellType: String {
        case height = "Height"
        case diameter = "Diameter"
        case mass = "Mass"
        case payload = "Payload"
    }
}
