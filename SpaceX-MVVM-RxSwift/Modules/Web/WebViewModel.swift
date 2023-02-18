//
//  WebViewModel.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 18.02.2023.
//

import Foundation

protocol WebViewModelType {
    var requestLink: URLRequest { get }
}

final class WebViewModel: WebViewModelType {
    var requestLink: URLRequest {
        guard !link.isEmpty else { return URLRequest(url: URL(string: "apple.com")!) }
        let urlString = URL(string: link)!
        return URLRequest(url: urlString)
    }

    private let link: String

    init(link: String) {
        self.link = link
    }
}
