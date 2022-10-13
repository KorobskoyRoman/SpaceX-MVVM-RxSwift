//
//  MainCell.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit

final class MainCell: UICollectionViewCell {
    static let reuseId = "MainCell"

    // MARK: - UI setup
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.showLoading(style: .large, color: UIColor.gray, text: "")
        return imageView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    private let successLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setConstraints()

        self.backgroundColor = .mainBackground().withAlphaComponent(0.4)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = Constraints.shadowRadius
        self.layer.shadowOpacity = Constraints.shadowOpacity
        self.layer.shadowOffset = CGSize(width: .zero, height: Constraints.shadowOffsetHeight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / Constraints.cornerMultiply
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        dateLabel.text = nil
        nameLabel.text = nil
        successLabel.text = nil
        image.showLoading()
    }

    // MARK: - Configure
    func configure(with model: LaunchInfo) {
        image.sd_setImage(with: URL(string: model.links.patch.small ?? "")) { _,_,_,_ in
            self.image.stopLoading()

            if self.image.image == nil {
                self.image.image = UIImage(systemName: "circle.slash")
            }
        }

        dateLabel.text = getDate(model.dateUTC ?? Date())
        nameLabel.text = model.name
        successLabel.text = getSuccessInfo(model.success ?? false)
    }

    private func setConstraints() {
        contentView.addSubview(image)
        contentView.addSubview(dateLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(successLabel)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset10),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            image.heightAnchor.constraint(equalToConstant: Insets.inset70),
            image.widthAnchor.constraint(equalToConstant: Insets.inset70),

            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Insets.inset10),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Insets.inset10),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            successLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset10),
            successLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10)
        ])
    }
}

extension MainCell {
    private func getSuccessInfo(_ success: Bool) -> String {
        switch success {
        case true:
            return "Успешно"
        case false:
            return "Провал"
        }
    }

    private func getDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        return formatter.string(from: date)
    }
}

private enum Constraints {
    static let cornerMultiply: CGFloat = 10
    static let shadowRadius: CGFloat = 3
    static let shadowOpacity: Float = 0.5
    static let shadowOffsetHeight = 4
}
