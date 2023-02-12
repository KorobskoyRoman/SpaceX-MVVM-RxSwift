//
//  MainCell.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import UIKit
import SDWebImage

final class MainCell: UICollectionViewCell {
    static let reuseId = "MainCell"

    // MARK: - UI setup
    private let image: ShimmerUIImageView = {
        let imageView = ShimmerUIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.startAnimating()
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
        label.font = .lab24
        return label
    }()
    private let successImage = UIImageView()

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
        image.layer.cornerRadius = image.frame.height / 2
        self.layer.cornerRadius = self.frame.height / Constraints.cornerMultiply
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        dateLabel.text = nil
        nameLabel.text = nil
        successImage.image = nil
//        image.showLoading(text: "")
    }

    // MARK: - Configure
    func configure(with model: LaunchesEntity) {
        image.sd_setImage(with: URL(string: model.links ?? "")) { [weak self] _,_,_,_ in
            guard let self else { return }
            guard self.image.image != nil else {
                self.image.image = UIImage(named: "noImage")
                self.image.stopLoading()
                return
            }
            self.image.stopAnimating()
        }

        dateLabel.text = getDate(model.dateUTC ?? Date())
        nameLabel.text = model.name
        successImage.image = getSuccessInfo(model.success)
    }

    private func setConstraints() {
        let successImageHeight: CGFloat = 40
        contentView.addSubview(image)
        contentView.addSubview(dateLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(successImage)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset10),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            image.heightAnchor.constraint(equalToConstant: Insets.inset70),
            image.widthAnchor.constraint(equalToConstant: Insets.inset70),

            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Insets.inset5),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Insets.inset5),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            successImage.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            successImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10),
            successImage.heightAnchor.constraint(equalToConstant: successImageHeight),
            successImage.widthAnchor.constraint(equalTo: successImage.heightAnchor)
        ])
    }
}

extension MainCell {
    private func getSuccessInfo(_ success: Bool) -> UIImage {
        switch success {
        case true:
            return UIImage(named: "success")!
        case false:
            return UIImage(named: "fail")!
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
