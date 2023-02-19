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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, LaunchesEntity>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LaunchesEntity>

    private lazy var collectionView = UICollectionView(frame: view.bounds,
                                                       collectionViewLayout: createCompositialLayout())
    private lazy var dataSource = createDiffableDataSource()

    private let toTopButton: ToTopButton
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
    private var viewModel: MainViewModelType

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reload()
        bind()
        viewModel.getLaunches()
        collectionView.stopLoading()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toTopButton.center.x += view.bounds.width
    }

    init(viewModel: MainViewModelType,
         toTopButton: ToTopButton = ToTopButton()) {
        self.viewModel = viewModel
        self.toTopButton = toTopButton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        navigationController?.navigationBar.isHidden = false
        view.showLoading()
        toTopButton.addTarget(self, action: #selector(toTopTapped), for: .touchUpInside)
        view.backgroundColor = .mainBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.leftBarButtonItem = settingsButton

        title = MainConstants.mainTitle
        setupCollectionView()
    }

    private func reload() {
        viewModel.reload = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.applySnapshot()
            }
        }
    }

    private func setupCollectionView() {
        collectionView.showLoading()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)

        collectionView.addSubview(toTopButton)
        toTopButton.translatesAutoresizingMaskIntoConstraints = false
        toTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toTopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        toTopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toTopButton.widthAnchor.constraint(equalTo: toTopButton.heightAnchor).isActive = true

        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.reuseId)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseId)
    }

    @objc private func toTopTapped() {
        let indexPath = IndexPath(item: .zero, section: .zero)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.toTopButton.buttonIsHidden = true
            self.toTopButton.hideButton(on: self.view)
        }
    }

    @objc private func filterTapped() {
        isFiltered.toggle()
        viewModel.filterFromLatest.accept(isFiltered)
    }

    @objc private func settingsTapped() {
        viewModel.pushToSettings()
    }
}

extension MainViewController {
    private func bind() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.dbLaunches.subscribe { [weak self] in
            if !$0.isEmpty {
                self?.view.stopLoading()
            }
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

// MARK: - Create DataSource
extension MainViewController {
    private func createDiffableDataSource() -> DataSource {
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

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()

        snapshot.appendSections([.mainSection])
        snapshot.appendItems(viewModel.dbLaunches.value, toSection: .mainSection)

        if snapshot.numberOfItems != 0 {
            view.stopLoading()
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.launchAt(indexPath: indexPath)
        self.viewModel.push(launch: item)
    }
}

extension MainViewController {
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
                    self.toTopButton.showButton(on: self.view)
                }
            }
            .disposed(by: disposeBag)
    }
}
