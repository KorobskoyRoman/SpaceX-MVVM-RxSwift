//
//  SettingsView.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 13.02.2023.
//

import UIKit
import RxSwift
import RxRelay

final class SettingsView: RxBaseView {

    let height = BehaviorRelay<Bool>(value: false)
    let diameter = BehaviorRelay<Bool>(value: false)
    let mass = BehaviorRelay<Bool>(value: false)
    let weight = BehaviorRelay<Bool>(value: false)

    let saveHeightState = PublishRelay<Void>()
    let saveDiameterState = PublishRelay<Void>()
    let saveMassState = PublishRelay<Void>()
    let saveWeightState = PublishRelay<Void>()

    private let heightLabel: UILabel = {
        return UILabelBuilder()
            .setText("Высота")
            .setFont(.lab16)
            .build()
    }()

    private lazy var heightSwitcher: CustomSwitch = {
        let switcher = CustomSwitch()
        switcher.addTarget(self, action: #selector(heightSwitched), for: .touchUpInside)
        return switcher
    }()

    private let diameterLabel: UILabel = {
        return UILabelBuilder()
            .setText("Диаметр")
            .setFont(.lab16)
            .build()
    }()

    private lazy var diameterSwitcher: CustomSwitch = {
        let switcher = CustomSwitch()
        switcher.addTarget(self, action: #selector(diameterSwitched), for: .touchUpInside)
        return switcher
    }()

    private let massLabel: UILabel = {
        return UILabelBuilder()
            .setText("Масса")
            .setFont(.lab16)
            .build()
    }()

    private lazy var massSwitcher: CustomSwitch = {
        let switcher = CustomSwitch()
        switcher.labelOn.text = "kg"
        switcher.labelOff.text = "lb"
        switcher.addTarget(self, action: #selector(massSwitched), for: .touchUpInside)

        return switcher
    }()

    private let weightLabel: UILabel = {
        return UILabelBuilder()
            .setText("Полезная нагрузка")
            .setFont(.lab16)
            .build()
    }()

    private lazy var weightSwitcher: CustomSwitch = {
        let switcher = CustomSwitch()
        switcher.labelOn.text = "kg"
        switcher.labelOff.text = "lb"
        switcher.addTarget(self, action: #selector(weightSwitched), for: .touchUpInside)
        return switcher
    }()

    // MARK: - Stacks
    private lazy var heightStack = UIStackView(
        arrangedSubviews: [heightLabel, heightSwitcher],
        axis: .horizontal,
        spacing: 20,
        distribution: .equalSpacing
    )

    private lazy var diameterStack = UIStackView(
        arrangedSubviews: [diameterLabel, diameterSwitcher],
        axis: .horizontal,
        spacing: 20,
        distribution: .equalSpacing
    )

    private lazy var massStack = UIStackView(
        arrangedSubviews: [massLabel, massSwitcher],
        axis: .horizontal,
        spacing: 20,
        distribution: .equalSpacing
    )

    private lazy var weightStack = UIStackView(
        arrangedSubviews: [weightLabel, weightSwitcher],
        axis: .horizontal,
        spacing: 20,
        distribution: .equalSpacing
    )

    private lazy var mainStack = UIStackView(
        arrangedSubviews: [
            heightStack,
            diameterStack,
            massStack,
            weightStack
        ],
        axis: .vertical,
        spacing: 20
    )

    // MARK: - Setup views
    private func setupStates() {
        height.bind(to: heightSwitcher.rx.isOn).disposed(by: bag)
        diameter.bind(to: diameterSwitcher.rx.isOn).disposed(by: bag)
        mass.bind(to: massSwitcher.rx.isOn).disposed(by: bag)
        weight.bind(to: weightSwitcher.rx.isOn).disposed(by: bag)
    }

    @objc func heightSwitched() {
        height.accept(!height.value)
        saveHeightState.accept(())
    }

    @objc func diameterSwitched() {
        diameter.accept(!diameter.value)
        saveDiameterState.accept(())
    }

    @objc func massSwitched() {
        mass.accept(!mass.value)
        saveMassState.accept(())
    }

    @objc func weightSwitched() {
        weight.accept(!weight.value)
        saveWeightState.accept(())
    }

    override func setupView() {
        backgroundColor = .mainBackground()
        setupStates()
    }

    override func setupHierarchy() {
        addSubview(mainStack)
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            heightSwitcher.heightAnchor.constraint(equalToConstant: 30),
            heightSwitcher.widthAnchor.constraint(equalToConstant: 70),

            diameterSwitcher.heightAnchor.constraint(equalToConstant: 30),
            diameterSwitcher.widthAnchor.constraint(equalToConstant: 70),

            massSwitcher.heightAnchor.constraint(equalToConstant: 30),
            massSwitcher.widthAnchor.constraint(equalToConstant: 70),

            weightSwitcher.heightAnchor.constraint(equalToConstant: 30),
            weightSwitcher.widthAnchor.constraint(equalToConstant: 70),

            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
