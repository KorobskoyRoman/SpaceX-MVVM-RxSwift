//
//  Date+.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 03.02.2023.
//

import Foundation

extension Date {
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        return formatter.string(from: self)
    }
}
