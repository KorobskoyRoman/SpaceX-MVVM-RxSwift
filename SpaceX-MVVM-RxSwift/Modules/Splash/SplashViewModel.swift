//
//  SplashViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 16.02.2023.
//

import RxSwift
import RxCocoa
import RxReachability
import Reachability

final class SplashViewModel: SplashModuleType, SplashViewModelType {

    let dependencies: Dependencies
    let moduleBindings = ModuleBindings()
    let bindings = Bindings()
    let commands = Commands()

    private let bag = DisposeBag()

    var showError: ((String) -> Void)?
    var hasError: Bool = false

    private var reachability = try? Reachability()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        configure(commands: commands)
        configure(bindings: bindings)
    }

    func configure(commands: Commands) {
        commands.viewDidAppear.bind(to: Binder<Void>(self) { target, _ in
            target.getLaunches()
        }).disposed(by: bag)
    }

    func configure(bindings: Bindings) {
        
    }

    private func startNotify() {
        try? reachability?.startNotifier()
    }

    func stopNotify() {
        reachability?.stopNotifier()
    }

    func fetchLaunches() {
        hasError = false
        getLaunches()
    }

    private func getLaunches() {
        // TODO: Launches service via dependencies
        Task {
            do {
                let launchs = try await dependencies.networkingService.fetchLaunches()
                launchs
                    .observe(on: MainScheduler.instance)
                    .subscribe { [weak self] in
                        guard let self else { return }
                        self.moduleBindings.launches.accept($0.element ?? [])
                    }
                    .disposed(by: bag)

                try dependencies.storage.save(launches: self.moduleBindings.launches)
            } catch {
                self.hasError = true
                showError?(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }

    private func bind() {
        // TODO: Reachability service via dependencies
        reachability?.rx.isReachable
            .subscribe (onNext: { isReachable in
                if !isReachable {
                    self.showError?(
                        ReachabilityError.unavailable.description + "\nВы можете нажать \"Повторить\" для повторной загрузки. \nПри нажатии \"Продолжить\" будут загружены ранее полученные данные."
                    )
                }
            })
            .disposed(by: bag)
    }
}
