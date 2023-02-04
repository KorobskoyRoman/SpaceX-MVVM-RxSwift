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
    var data: BehaviorRelay<Rocket>? = nil

    private let bag = DisposeBag()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .lab32
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            DetailCollectionCell.self,
            forCellWithReuseIdentifier: DetailCollectionCell.reuseId
        )
        return collectionView
    }()

    private let firtLaunchText: UILabel = {
        let label = UILabel()
        label.font = .lab16
        label.textColor = .gray
        label.text = TitleConstants.dateLabel
        return label
    }()

    private let firstLaunchValue: UILabel = {
        let label = UILabel()
        label.font = .lab16
        return label
    }()

    private let countryText: UILabel = {
        let label = UILabel()
        label.font = .lab16
        label.textColor = .gray
        label.text = TitleConstants.countryLabel
        return label
    }()

    private let countryValue: UILabel = {
        let label = UILabel()
        label.font = .lab16
        return label
    }()

    private lazy var costText: UILabel = {
        let label = UILabel()
        label.font = .lab16
        label.textColor = .gray
        label.text = TitleConstants.costLabel
        return label
    }()

    lazy var costValue: UILabel = {
        let label = UILabel()
        label.font = .lab16
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }

    private lazy var firstLaunchStack = UIStackView(arrangedSubviews: [firtLaunchText,
                                                                firstLaunchValue],
                                             axis: .horizontal,
                                             spacing: Insets.inset10,
                                             distribution: .equalCentering)

    private lazy var countryStack = UIStackView(arrangedSubviews: [countryText,
                                                                   countryValue],
                                                axis: .horizontal,
                                                spacing: Insets.inset10,
                                                distribution: .equalCentering)

    private lazy var costStack = UIStackView(arrangedSubviews: [costText,
                                                                costValue],
                                             axis: .horizontal,
                                             spacing: Insets.inset10,
                                             distribution: .equalCentering)

    private lazy var mainStack = UIStackView(arrangedSubviews: [
        firstLaunchStack,
        countryStack,
        costStack
    ],
                                             axis: .vertical,
                                             spacing: Insets.inset10,
                                             aligment: .fill,
                                             distribution: .equalCentering)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layer.cornerRadius = self.frame.height / 15
        self.layer.cornerRadius = 15
    }

    func configure(
        with rocket: BehaviorRelay<Rocket>,
        and launch: BehaviorRelay<LaunchInfo>
    ) {
        rocket.map {
            $0.name
        }
        .bind(to: nameLabel.rx.text)
        .disposed(by: bag)

        launch.map {
            $0.dateUTC.toString
        }
        .bind(to: firstLaunchValue.rx.text)
        .disposed(by: bag)

        rocket.map {
            $0.country
        }
        .bind(to: countryValue.rx.text)
        .disposed(by: bag)

        rocket.map {
            $0.costPerLaunch.toDollars
        }
        .bind(to: costValue.rx.text)
        .disposed(by: bag)
    }

    private func setConstraints() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(mainStack)
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset32),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset32),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset32),

            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Insets.inset20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10),
            collectionView.heightAnchor.constraint(equalToConstant: 120),

            mainStack.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: Insets.inset32),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset32),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset32)
        ])
    }
}

extension DetailCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailCollectionCell.reuseId,
            for: indexPath
        ) as? DetailCollectionCell else {
            return UICollectionViewCell()
        }

        switch indexPath.item {
        case 0: cell.configure(with: .height, value: data?.value.height.feet)
        case 1: cell.configure(with: .diameter, value: data?.value.diameter.feet)
        case 2: cell.configure(with: .mass, value: data?.value.mass.lb)
        default: cell.configure(with: .payload, value: data?.value.payloadWeights.first?.lb)
        }

        return cell
    }
}

extension DetailCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = 100
        return CGSize(width: size, height: size)
    }
}

extension DetailCell {
    private enum TitleConstants {
        static let dateLabel = "Первый запуск:"
        static let countryLabel = "Страна:"
        static let costLabel = "Стоимость запуска:"
    }
}
