//
//  DetailView.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 14.07.2023.
//

import UIKit
import RxSwift
import RxRelay

final class DetailView: RxBaseView {

    let launch = BehaviorRelay<LaunchesEntity?>(value: nil)
    let rocket = BehaviorRelay<Rocket?>(value: nil)
    let rocketDetail = BehaviorRelay<RocketDetail?>(value: nil)
    let image = BehaviorRelay<String?>(value: nil)

    lazy var tableView = UITableView()

    private var headerView = DetailHeader()
    private var headerHeightConstraint: NSLayoutConstraint?
    private let headerHeight: CGFloat = 200

    override func setupHierarchy() {
        addSubview(headerView)
        addSubview(tableView)
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    override func setupView() {
        setupHeader()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 15

        tableView.register(
            DetailCell.self,
            forCellReuseIdentifier: DetailCell.reuseId
        )
        tableView.register(
            AdditionalDetailCell.self,
            forCellReuseIdentifier: AdditionalDetailCell.reuseId
        )
    }
}

extension DetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return 500 // переделать под динамик сайз
        switch indexPath.section {
        case 0: return 350
        default:
            return 100
        }
    }
}

extension DetailView: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            3
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DetailCell.reuseId,
                    for: indexPath) as? DetailCell
                else { return UITableViewCell() }
                cell.rocketDetail = rocketDetail.value
                cell.configure(with: rocket,
                               and: launch)

                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: AdditionalDetailCell.reuseId,
                    for: indexPath) as? AdditionalDetailCell
                else { return UITableViewCell() }

                cell.configure(
                    with: rocket,
                    and: .firstLaunchInfo
                )

                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: AdditionalDetailCell.reuseId,
                    for: indexPath) as? AdditionalDetailCell
                else { return UITableViewCell() }
                cell.configure(
                    with: rocket,
                    and: .secondLaunchInfo
                )

                return cell

            }
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            case 1: return "First stage".uppercased()
            case 2: return "Second stage".uppercased()
            default:
                return ""
            }
        }
    }

// MARK: - Header setup

extension DetailView {
    private func setupHeader() {
        headerView = DetailHeader(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(headerView)

        //        viewModel.image
        //            .observe(on: MainScheduler.instance)
        //            .subscribe { [weak self] in
        //                self?.headerView.configure(with: $0.element ?? "")
        //            }.disposed(by: disposeBag)
        image.observe(on: MainScheduler.instance)
            .filterNil()
            .subscribe(onNext: { [weak self] in
                self?.headerView.configure(with: $0)
            }).disposed(by: bag)

        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint!.isActive = true
    }

    func animateHeader() {
        self.headerHeightConstraint?.constant = headerHeight
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navBarHeight: CGFloat = 44
//        additionalSafeAreaInsets.top
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
