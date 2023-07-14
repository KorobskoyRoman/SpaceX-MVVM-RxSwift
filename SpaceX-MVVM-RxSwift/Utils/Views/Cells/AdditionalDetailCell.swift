//
//  AdditionalDetailCell.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 04.02.2023.
//

import UIKit
import RxSwift
import RxRelay

final class AdditionalDetailCell: UITableViewCell {
    static let reuseId = "AdditionalDetailCell"
    private let bag = DisposeBag()

    private let enginesCountLabel: UILabel = {
        let label = UILabel()
        label.font = .lab16
        label.textColor = .gray
        label.text = Titleconstants.enginesCount.rawValue
        return label
    }()

    private let enginesCountValue: UILabel = {
        let label = UILabel()
        label.font = .lab16
        return label
    }()

    private let fuelCountLabel: UILabel = {
        let label = UILabel()
        label.font = .lab16
        label.textColor = .gray
        label.text = Titleconstants.fuelCount.rawValue
        return label
    }()

    private let fuelCountValue: UILabel = {
        let label = UILabel()
        label.font = .lab16
        return label
    }()

    private let burnTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .lab16
        label.textColor = .gray
        label.text = Titleconstants.burnTime.rawValue
        return label
    }()

    private let burnTimeValue: UILabel = {
        let label = UILabel()
        label.font = .lab16
        return label
    }()

    private lazy var enginesStack = UIStackView(
        arrangedSubviews: [enginesCountLabel,
                           enginesCountValue],
        axis: .horizontal,
        spacing: Insets.inset10,
        distribution: .equalCentering
    )

    private lazy var fuelStack = UIStackView(
        arrangedSubviews: [fuelCountLabel,
                           fuelCountValue],
        axis: .horizontal,
        spacing: Insets.inset10,
        distribution: .equalCentering
    )

    private lazy var burnStack = UIStackView(
        arrangedSubviews: [burnTimeLabel,
                           burnTimeValue],
        axis: .horizontal,
        spacing: Insets.inset10,
        distribution: .equalCentering
    )

    private lazy var mainStack = UIStackView(
        arrangedSubviews: [
            enginesStack,
            fuelStack,
            burnStack
        ],
        axis: .vertical,
        spacing: Insets.inset10,
        aligment: .fill,
        distribution: .equalCentering
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        with rocket: BehaviorRelay<Rocket?>,
        and type: DetailCellType
    ) {
        switch type {
        case .firstLaunchInfo:
            rocket.filterNil()
                .map { "\($0.firstStage.engines)" }
                .bind(to: enginesCountValue.rx.text)
                .disposed(by: bag)

            rocket.filterNil()
                .map { "\($0.firstStage.fuelAmountTons) ton" }
                .bind(to: fuelCountValue.rx.text)
                .disposed(by: bag)

            rocket.filterNil()
                .map { "\($0.firstStage.burnTimeSEC ?? 0) sec" }
                .bind(to: burnTimeValue.rx.text)
                .disposed(by: bag)
        case .secondLaunchInfo:
            rocket.filterNil()
                .map { "\($0.secondStage.engines)" }
                .bind(to: enginesCountValue.rx.text)
                .disposed(by: bag)

            rocket.filterNil()
                .map { "\($0.secondStage.fuelAmountTons) ton" }
                .bind(to: fuelCountValue.rx.text)
                .disposed(by: bag)

            rocket.filterNil()
                .map { "\($0.secondStage.burnTimeSEC ?? 0) sec" }
                .bind(to: burnTimeValue.rx.text)
                .disposed(by: bag)
        }
    }

    private func setConstraints() {
        contentView.addSubview(mainStack)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: Insets.inset20),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset32),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset32)
        ])
    }
}

extension AdditionalDetailCell {
    enum Titleconstants: String {
        case enginesCount = "Количество двигателей"
        case fuelCount = "Количество топлива"
        case burnTime = "Время сгорания"
    }
}
