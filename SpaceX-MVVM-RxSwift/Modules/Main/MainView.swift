//
//  MainView.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 10.07.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class MainView: RxBaseView {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, LaunchesEntity>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LaunchesEntity>

    var dbLaunches = BehaviorRelay<[LaunchesEntity]>(value: [])
    let refresh = PublishRelay<Void>()

    lazy var collectionView = UICollectionView(
        frame: self.bounds,
        collectionViewLayout: createCompositialLayout()
    )

    lazy var dataSource = createDiffableDataSource()
    let toTopButton: ToTopButton = ToTopButton()
    private let refreshControl = UIRefreshControl()

    override func setupBinding() {
        super.setupBinding()

        toTopButton.addTarget(self, action: #selector(toTopTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshDragged), for: .valueChanged)
        collectionView.rx.setDelegate(self).disposed(by: bag)
    }

    override func setupView() {
        super.setupView()
        collectionView.showLoading()
        collectionView.refreshControl = refreshControl
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.reuseId)
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseId
        )
    }

    override func setupHierarchy() {
        super.setupHierarchy()
        self.addSubview(collectionView)
        collectionView.addSubview(toTopButton)
    }

    override func setupLayout() {
        super.setupLayout()
        toTopButton.translatesAutoresizingMaskIntoConstraints = false
        toTopButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        toTopButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100).isActive = true
        toTopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toTopButton.widthAnchor.constraint(equalTo: toTopButton.heightAnchor).isActive = true
    }
}

extension MainView {
    @objc private func toTopTapped() {
        let indexPath = IndexPath(item: .zero, section: .zero)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.toTopButton.buttonIsHidden = true
            self.toTopButton.hideButton(on: self)
        }
    }

    @objc private func refreshDragged() {
        refresh.accept(())
        refreshControl.endRefreshing()
    }
}

extension MainView {
    // MARK: - Create layout
    func createCompositialLayout() -> UICollectionViewLayout {
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

    func createMainSection() -> NSCollectionLayoutSection {
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

// MARK: - Create DataSource
extension MainView {
    func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, data in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("No section")
            }
            switch section {
            case .mainSection:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.reuseId,
                                                                    for: indexPath) as? MainCell
                else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
            }
        }

        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()

        snapshot.appendSections([.mainSection])
        snapshot.appendItems(dbLaunches.value, toSection: .mainSection)

        if snapshot.numberOfItems != 0 {
            self.stopLoading()
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension MainView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Button: - \(toTopButton.center.x)")
        print("Scroll view: - \(scrollView.contentOffset.y)")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.rx.contentOffset
            .distinctUntilChanged()
            .subscribe { [weak self] element in
                guard let self else { return }
                if element.element?.y ?? 0 >= 100 && self.toTopButton.buttonIsHidden {
                    self.toTopButton.buttonIsHidden = false
                    self.toTopButton.showButton(on: self)
                }
            }.disposed(by: bag)
    }
}
