//
//  DetailViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: RxBaseViewController<DetailView> {
    
    var viewModel: DetailViewModelType!
    
    override func setupBinding() {
        setupNav()
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }
    
    private func configure(_ commands: DetailViewModel.Commands) {

    }
    
    private func configure(_ bindings: DetailViewModel.Bindings) {
        bindings.launch.bind(to: contentView.launch).disposed(by: bag)
        bindings.rocket.bind(to: contentView.rocket).disposed(by: bag)
        bindings.rocketDetail.bind(to: contentView.rocketDetail).disposed(by: bag)
        bindings.image.bind(to: contentView.image).disposed(by: bag)

        contentView.ytLink.bind(to: bindings.openWeb).disposed(by: bag)
        contentView.wikiLink.bind(to: bindings.openWeb).disposed(by: bag)
    }
    
    func setupNav() {
        viewModel.bindings.title.bind(to: rx.title).disposed(by: bag)
        view.backgroundColor = .mainBackground()
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
