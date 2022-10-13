//
//  DetailViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 12.10.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModelType
    private let image: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noImage"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let rocketInfoView = RocketInfoView()

    init(viewModel: DetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func setupView() {
        view.backgroundColor = .red
        setConstraints()
    }

    private func setConstraints() {
        view.addSubview(image)
        view.addSubview(rocketInfoView)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 200),

            rocketInfoView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: -20),
            rocketInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rocketInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rocketInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
