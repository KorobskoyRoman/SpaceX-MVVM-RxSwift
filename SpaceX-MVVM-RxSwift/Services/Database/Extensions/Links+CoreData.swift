//
//  Links+CoreData.swift
//  SpaceX-MVVM-RxSwift
//
//  Created by Roman Korobskoy on 08.02.2023.
//

import CoreData

extension LaunchesEntity {
    var patchValue: Patch {
        get {
            guard let value = link?.patch else {
                return Patch(small: "")
            }
            let patch = Patch(small: value)
            return patch
        } set {
            self.link?.patch = newValue.small
        }
    }

    var webcastValue: String {
        get {
            guard let value = link?.webcast else {
                return ""
            }
            return value
        } set {
            self.link?.webcast = newValue
        }
    }

    var articleValue: String {
        get {
            guard let value = link?.article else {
                return ""
            }
            return value
        } set {
            self.link?.article = newValue
        }
    }

    var linksValue: Links {
        get {
            let link = Links(patch: patchValue, webcast: webcastValue, article: "")
            return link
        } set {
            self.links = newValue.patch.small // ???
        }
    }
}
