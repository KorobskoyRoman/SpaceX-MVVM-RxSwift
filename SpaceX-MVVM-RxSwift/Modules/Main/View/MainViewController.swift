//
//  MainViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 01.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, LaunchInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LaunchInfo>

    private lazy var collectionView = UICollectionView(frame: view.bounds,
                                                       collectionViewLayout: createCompositialLayout())
    private let disposeBag = DisposeBag()

    private var viewModel: MainViewModelType

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getLaunches()
        setupView()
        bind()
        reload()
    }

    init(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        reload()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.showLoading(style: .large)
        view.backgroundColor = .mainBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = MainConstants.mainTitle
        setupCollectionView()
    }

    private func reload() {
        viewModel.reload = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.view.stopLoading()
            }
        }
    }

    private func setupCollectionView() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)

        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.reuseId)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseId)
    }
}

extension MainViewController {
    private func bind() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.launches
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items) { collectionView, item, model in
                //                guard let self else { return UICollectionViewCell() }
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainCell.reuseId,
                    for: IndexPath(item: item, section: 0)
                ) as? MainCell else { return UICollectionViewCell() }
                cell.configure(with: model)

                return cell
            }.disposed(by: disposeBag)
    }
}

// MARK: - Create layout
extension MainViewController {
    private func createCompositialLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Section not found")
            }
            switch section {
            case .mainSection:
                return self.createMainSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = HelpConstants.Constraints.interSectionSpacing
        layout.configuration = config
        return layout
    }

    private func createMainSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(HelpConstants.Constraints.cellWidth),
                                              heightDimension: .absolute(HelpConstants.Constraints.cellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(
            top: HelpConstants.Constraints.topItemInset,
            leading: HelpConstants.Constraints.itemInset,
            bottom: HelpConstants.Constraints.itemInset,
            trailing: HelpConstants.Constraints.itemInset)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: HelpConstants.Constraints.groupSize)

        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = HelpConstants.Constraints.interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: HelpConstants.Constraints.topItemInset,
            leading: HelpConstants.Constraints.itemInset,
            bottom: .zero,
            trailing: HelpConstants.Constraints.itemInset)

        return section
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkService().fetchRocket(id: viewModel.launchAt(indexPath: indexPath).rocket ?? "",
                                     completion: { [weak self] result in
            guard let self else { return }
            self.viewModel.push(launch: self.viewModel.launchAt(indexPath: indexPath))
        })
    }
}
