//
//  Section.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 02.10.2022.
//

import Foundation

enum Section: Int, CaseIterable {
    case mainSection

    func description() -> String {
        switch self {
        case .mainSection:
            return SectionInfo.name
        }
    }
}

private enum SectionInfo {
    static let name = "Recent launches"
}
