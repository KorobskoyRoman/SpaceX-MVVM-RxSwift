//
//  InfoAlert.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 03.03.2023.
//

import UIKit

final class InfoAlert: UIView {
    var actionRetry: (() -> Void)?
    var actionCancel: (() -> Void)?

    lazy var infoLabel: UILabel = {
        return UILabelBuilder()
            .setFont(UIFont.systemFont(ofSize: 16))
            .numberOfLines(0)
            .build()
    }()

    private lazy var cancelButton: UIButton = {
        return UIButtonBuilder()
            .cornerRadius(5)
            .backgroundColor(.systemBlue.withAlphaComponent(0.5))
            .title("Продолжить")
            .tintColor(.systemRed)
            .setFont(UIFont.systemFont(ofSize: 14, weight: .regular))
            .build()
    }()

    private lazy var retryButton: UIButton = {
        return UIButtonBuilder()
            .cornerRadius(5)
            .backgroundColor(.systemBlue.withAlphaComponent(0.5))
            .title("Перезагрузить")
            .tintColor(.black)
            .setFont(UIFont.systemFont(ofSize: 14, weight: .heavy))
            .build()
    }()

    private lazy var buttonsStack = UIStackView(
        arrangedSubviews: [cancelButton, retryButton],
        axis: .horizontal,
        spacing: 10,
        distribution: .fillEqually
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }
}

private extension InfoAlert {
    func setupView() {
        self.alpha = 0.0
        backgroundColor = .infoAlertBackground()
        addSubview(infoLabel)
        addSubview(buttonsStack)

        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            buttonsStack.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

private extension InfoAlert {
    func setActions() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    @objc func cancelTapped() {
        actionCancel?()
    }

    @objc func retryTapped() {
        actionRetry?()
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: UIViewRepresentable
    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

struct BestInClassPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = InfoAlert(frame: CGRect(x: 100, y: 100, width: 150, height: 100))
            view.infoLabel.text = "skdadsalkdakd aksda sk a jdsakdj as jaskdj aksj akjdj kfgjkfas kfgj ksgsjfg lg asjg ljsfgjaflgjfan gjg nsjo gjs nofa g[oas sd"
            return view
        }
    }
}
#endif
