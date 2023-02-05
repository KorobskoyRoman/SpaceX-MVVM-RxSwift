////
////  RocketInfoView.swift
////  SpaceX-MVVM-RxSwift
////
////  Created by Roman Korobskoy on 12.10.2022.
////
//
//import UIKit
//
//protocol RocketInfoType: UIView {
//    var nameLabel: UILabel { get }
//    var dateLabel: UILabel { get }
//    var countryLabel: UILabel { get }
//    var costLabel: UILabel { get }
//}
//
//final class RocketInfoView: UIView, RocketInfoType {
//    lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .lab24
//        return label
//    }()
//
//    private lazy var dateText: UILabel = {
//        let label = UILabel()
//        label.font = .lab16
//        label.textColor = .gray
//        label.text = TitleConstants.dateLabel
//        return label
//    }()
//
//    lazy var dateLabel: UILabel = {
//        let label = UILabel()
//        label.font = .lab16
//        return label
//    }()
//
//    private lazy var countryText: UILabel = {
//        let label = UILabel()
//        label.font = .lab16
//        label.textColor = .gray
//        label.text = TitleConstants.countryLabel
//        return label
//    }()
//
//    lazy var countryLabel: UILabel = {
//        let label = UILabel()
//        label.font = .lab16
//        return label
//    }()
//
//    private lazy var costText: UILabel = {
//        let label = UILabel()
//        label.font = .lab16
//        label.textColor = .gray
//        label.text = TitleConstants.costLabel
//        return label
//    }()
//
//    lazy var costLabel: UILabel = {
//        let label = UILabel()
//        label.font = .lab16
//        return label
//    }()
//
//    private lazy var dateStack = UIStackView(arrangedSubviews: [dateText,
//                                                                dateLabel],
//                                             axis: .horizontal,
//                                             spacing: Insets.inset10,
//                                             distribution: .equalCentering)
//
//    private lazy var countryStack = UIStackView(arrangedSubviews: [countryText,
//                                                                   countryLabel],
//                                                axis: .horizontal,
//                                                spacing: Insets.inset10,
//                                                distribution: .equalCentering)
//
//    private lazy var costStack = UIStackView(arrangedSubviews: [costText,
//                                                                costLabel],
//                                             axis: .horizontal,
//                                             spacing: Insets.inset10,
//                                             distribution: .equalCentering)
//
//    private lazy var mainStack = UIStackView(arrangedSubviews: [
//        dateStack,
//        countryStack,
//        costStack
//    ],
//                                             axis: .vertical,
//                                             spacing: Insets.inset10,
//                                             aligment: .fill,
//                                             distribution: .equalCentering)
//
//    init() {
//        super.init(frame: .zero)
//        self.backgroundColor = .white
//        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        setConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.layer.cornerRadius = self.frame.height / 15
//    }
//
//    private func setConstraints() {
//        addSubview(nameLabel)
//        addSubview(mainStack)
//        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
//
//        NSLayoutConstraint.activate([
//            nameLabel.topAnchor.constraint(equalTo: self.topAnchor,
//                                           constant: Insets.inset48),
//            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
//                                               constant: Insets.inset32),
//            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
//                                                constant: -Insets.inset32),
//
//            mainStack.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: Insets.inset32),
//            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Insets.inset32),
//            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Insets.inset32)
//        ])
//    }
//}
//
//enum TitleConstants {
//    static let dateLabel = "Первый запуск:"
//    static let countryLabel = "Страна:"
//    static let costLabel = "Стоимость запуска:"
//}
