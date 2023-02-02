////
////  DetailViewController.swift
////  SpaceX-MVVM-RxSwift
////
////  Created by Roman Korobskoy on 12.10.2022.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import SDWebImage
//
//final class DetailViewController: UIViewController {
//    private let viewModel: DetailViewModelType
//    private let disposeBag = DisposeBag()
//    private let image: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "noImage"))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//
//    private let rocketInfoView: RocketInfoType
//
//    init(viewModel: DetailViewModelType, rocketView: RocketInfoType = RocketInfoView()) {
//        self.viewModel = viewModel
//        self.rocketInfoView = rocketView
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationItem.largeTitleDisplayMode = .never
//        self.navigationItem.largeTitleDisplayMode = .never
//    }
//
//    private func setupView() {
//        view.backgroundColor = .mainBackground()
//        title = viewModel.title
//        bind()
//        setConstraints()
//    }
//
//    private func bind() {
//        let url = URL(string: viewModel.image)
//        image.sd_setImage(with: url)
//        viewModel.name
//            .asDriver(onErrorJustReturn: "n/a")
//            .drive(rocketInfoView.nameLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.date
//            .asDriver(onErrorJustReturn: "n/a")
//            .drive(rocketInfoView.dateLabel.rx.text)
//            .disposed(by: disposeBag)
//
////        viewModel.country
////            .asDriver(onErrorJustReturn: "n/a")
////            .drive(rocketInfoView.countryLabel.rx.text)
////            .disposed(by: disposeBag)
////
////        viewModel.cost
////            .asDriver(onErrorJustReturn: "n/a")
////            .drive(rocketInfoView.costLabel.rx.text)
////            .disposed(by: disposeBag)
//    }
//
//    private func setConstraints() {
//        let imageHeight: CGFloat = 200
//
//        view.addSubview(image)
//        view.addSubview(rocketInfoView)
//        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
//
//        NSLayoutConstraint.activate([
//            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            image.heightAnchor.constraint(equalToConstant: imageHeight),
//
//            rocketInfoView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: -Insets.inset20),
//            rocketInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            rocketInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            rocketInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
