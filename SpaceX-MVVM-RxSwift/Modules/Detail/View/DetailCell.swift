//
//  DetailCell.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.02.2023.
//

import UIKit
import RxSwift
import RxRelay

final class DetailCell: UITableViewCell {
    static let reuseId = "DetailCell"
    private let bag = DisposeBag()

    private let data: Rocket? = nil

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .lab24
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layer.cornerRadius = self.frame.height / 15
        self.layer.cornerRadius = 15
    }

//    func configure(with rocket: Rocket) {
//
//    }
    func configure(with rocket: BehaviorRelay<Rocket>) {
        rocket.map {
            $0.name
        }
        .bind(to: nameLabel.rx.text)
        .disposed(by: bag)
    }

    private func setConstraints() {
        contentView.addSubview(nameLabel)
        contentView.subviews.forEach
        {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset20),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10)
        ])
    }
}
