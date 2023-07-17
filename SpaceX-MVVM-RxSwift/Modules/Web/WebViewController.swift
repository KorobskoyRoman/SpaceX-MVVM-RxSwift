//
//  WebViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 18.02.2023.
//

import UIKit
import WebKit
import RxSwift

final class WebViewController: UIViewController {

    var viewModel: WebViewModelType!

    private var webView = WKWebView()
    private let bag = DisposeBag()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        return progressView
    }()

    private func setupBinding() {
        configure(viewModel.bindings)
        configure(viewModel.commands)
    }

    private func configure(_ commands: WebViewModel.Commands) {

    }

    func configure(_ bindings: WebViewModel.Bindings) {
        bindings.downloadLink.bind(to: Binder(self) { target, _ in
            target.startDownload()
        }).disposed(by: bag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupView()
        setConstraints()
        setupBinding()
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

extension WebViewController {
    private func hideContent() {
        UIView.animate(withDuration: 0.3, delay: 1) {
            self.progressView.alpha = 0
            self.progressView.removeFromSuperview()
        }
    }

    private func setupView() {
        view = webView
        webView.navigationDelegate = self
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }

    private func setConstraints() {
        webView.addSubview(progressView)
        webView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }

    private func startDownload() {
        guard let url = viewModel.bindings.downloadLink.value else { return }
        let urlString = URL(string: url)!
        let request = URLRequest(url: urlString)
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideContent()
    }
}
