//
//  Int+.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 03.02.2023.
//

import Foundation

extension Int {
    var toDollars: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M $"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K $"
        }
        else {
            return "\(self) $"
        }
    }
}
