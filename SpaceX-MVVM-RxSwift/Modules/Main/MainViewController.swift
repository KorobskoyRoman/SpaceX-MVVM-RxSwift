//
//  MainViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: RxBaseViewController<MainView> {

    var viewModel: MainViewModelType!

    private lazy var filterButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.up.and.down.text.horizontal"),
        style: .plain,
        target: self,
        action: #selector(filterTapped))

    private lazy var settingsButton = UIBarButtonItem(
        image: UIImage(systemName: "gearshape"),
        style: .plain,
        target: self,
        action: #selector(settingsTapped))

    private var isFiltered = false

    private let disposeBag = DisposeBag()

    override func setupBinding() {
        setupNav()
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.bindings.startNotify.accept(())
        contentView.toTopButton.center.x += view.bounds.width
        viewModel.bindings.getLaunches.accept(())
        viewModel.bindings.updateData.accept(())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.bindings.stopNotify.accept(())
    }

    private func configure(_ commands: MainViewModel.Commands) {

    }

    private func configure(_ bindings: MainViewModel.Bindings) {
//        contentView.collectionView.rx.modelSelected(LaunchesEntity.self)
        contentView.collectionView.rx.itemSelected
            .subscribe(onNext: { model in
//                print($0)
                let launch = bindings.launches.value[model.item]
                bindings.openDetails.accept(launch)
            }).disposed(by: bag)
//            .bind(to: Binder<LaunchesEntity>(self) { _, model in
//                print(model)
//                bindings.openDetails.accept(model)
//            }).disposed(by: bag)


        bindings.updateData.bind(to: Binder(self) { target, _ in
            target.reload()
        }).disposed(by: bag)

        bindings.launches.bind(to: contentView.dbLaunches).disposed(by: bag)
        contentView.refresh.bind(to: bindings.updateData).disposed(by: bag)
    }

    private func setupNav() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .mainBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.leftBarButtonItem = settingsButton

        title = MainConstants.mainTitle
    }

    private func reload() {
        contentView.applySnapshot()
    }
}

extension MainViewController {
    @objc private func filterTapped() {
        isFiltered.toggle()
//        viewModel.filterFromLatest.accept(isFiltered)
    }

    @objc private func settingsTapped() {
//        viewModel.pushToSettings()
    }
}
