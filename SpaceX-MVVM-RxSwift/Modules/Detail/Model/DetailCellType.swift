//
//  DetailCellType.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 04.02.2023.
//

import Foundation

extension AdditionalDetailCell {
    enum DetailCellType {
        case firstLaunchInfo
        case secondLaunchInfo
    }

    enum DetailStage: String {
        case firstStage
        case secondStage
    }
}
