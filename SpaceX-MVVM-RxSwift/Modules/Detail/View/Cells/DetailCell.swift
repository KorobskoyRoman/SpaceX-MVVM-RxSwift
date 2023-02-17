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

    var viewModel: DetailViewModelType?

    private let bag = DisposeBag()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .lab32
        return label
    }()

    private let wikiButton: UIButton = {
        return UIButtonBuilder()
            .title("Wikipedia")
            .backgroundColor(.lightGray)
            .cornerRadius(5)
            .build()
    }()

    private let videoButton: UIButton = {
        return UIButtonBuilder()
            .title("YouTube")
            .backgroundColor(.systemRed)
            .cornerRadius(5)
            .build()
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

    private lazy var linksStack = UIStackView(
        arrangedSubviews: [
            wikiButton,
            videoButton
        ],
        axis: .horizontal,
        spacing: 20,
        distribution: .fillEqually
    )

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

    private var wikiLink = ""
    private var videoLink = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15
    }

    private func setupView() {
        wikiButton.addTarget(self, action: #selector(wikiButtonTapped), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
    }

    func configure(
        with rocket: BehaviorRelay<Rocket>,
        and launch: BehaviorRelay<LaunchesEntity>
    ) {
        rocket.map {
            $0.name
        }
        .bind(to: nameLabel.rx.text)
        .disposed(by: bag)

        launch.map {
            $0.dateUTC?.toString
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

        rocket.map {
            $0.wikipedia
        }
        .subscribe {
            self.wikiLink = $0
        }
        .disposed(by: bag)

        launch.map {
            $0.webcast ?? ""
        }
        .subscribe {
            self.videoLink = $0
        }
        .disposed(by: bag)
    }

    private func setConstraints() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(linksStack)
        contentView.addSubview(collectionView)
        contentView.addSubview(mainStack)
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset32),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset32),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset32),

            linksStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Insets.inset10),
            linksStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset32),
            linksStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset32),
            linksStack.heightAnchor.constraint(equalToConstant: Insets.inset32),

            collectionView.topAnchor.constraint(equalTo: linksStack.bottomAnchor, constant: Insets.inset20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10),
            collectionView.heightAnchor.constraint(equalToConstant: 120),

            mainStack.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: Insets.inset32),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset32),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset32)
        ])
    }
}

private extension DetailCell {
    @objc
    func wikiButtonTapped() {
        print(wikiLink)
    }

    @objc
    func videoButtonTapped() {
        print(videoLink)
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
        case 0: cell.configure(with: .height, value: viewModel?.height)
        case 1: cell.configure(with: .diameter, value: viewModel?.diameter)
        case 2: cell.configure(with: .mass, value: viewModel?.mass)
        default: cell.configure(with: .payload, value: viewModel?.weight)
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
