//
//  DetailViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModelType
    private lazy var tableView = UITableView()
    private var headerView: DetailHeader
    private var headerHeightConstraint: NSLayoutConstraint?
    private let headerHeight: CGFloat = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    init(viewModel: DetailViewModelType,
         headerView: DetailHeader = DetailHeader()) {
        self.viewModel = viewModel
        self.headerView = headerView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        title = viewModel.title
        view.backgroundColor = .mainBackground()

        navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.largeTitleDisplayMode = .never

        setupHeader()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .none

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 15

        tableView.register(DetailCell.self,
                           forCellReuseIdentifier: DetailCell.reuseId)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500 // переделать под динамик сайз
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseId, for: indexPath) as? DetailCell
        else { return UITableViewCell() }
//        cell.configure(with:
//                        viewModel.rocketInfo?.value
//                       ?? .emptyRocket
//        )
        guard let info = viewModel.rocketInfo else { return cell }
        cell.configure(with: info)
        cell.data = info

        return cell
    }
}

// MARK: - Header setup

extension DetailViewController {
    private func setupHeader() {
        headerView = DetailHeader(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        headerView.configure(with: viewModel.image)

        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint!.isActive = true

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    func animateHeader() {
        self.headerHeightConstraint?.constant = headerHeight
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navBarHeight = additionalSafeAreaInsets.top
        if scrollView.contentOffset.y < 0 {
            self.headerHeightConstraint?.constant += abs(scrollView.contentOffset.y)
        } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint!.constant >= navBarHeight {
            self.headerHeightConstraint?.constant -= scrollView.contentOffset.y
            if self.headerHeightConstraint!.constant <= navBarHeight {
                self.headerHeightConstraint?.constant = navBarHeight
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint!.constant > headerHeight {
            animateHeader()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint!.constant > headerHeight {
            animateHeader()
        }
    }
}
