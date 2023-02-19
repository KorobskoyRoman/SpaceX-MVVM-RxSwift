//
//  WebViewController.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 18.02.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let viewModel: WebViewModelType

    private var webView = WKWebView()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        return progressView
    }()

    init(viewModel: WebViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        startDownload()
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            print(progressView.progress)
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
        self.webView.load(self.viewModel.requestLink)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideContent()
    }
}
