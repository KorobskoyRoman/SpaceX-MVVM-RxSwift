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
        label.font = .lab24
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

    func configure(with rocket: BehaviorRelay<Rocket>) {
        rocket.map {
            $0.name
        }
        .bind(to: nameLabel.rx.text)
        .disposed(by: bag)
    }

    private func setConstraints() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(collectionView)
        contentView.subviews.forEach
        {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset32),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10),

            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Insets.inset20),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset10),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset10),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
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
