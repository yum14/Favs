//
//  RealmHelper.swift
//  Favs
//
//  Created by yum on 2021/04/09.
//

import Foundation
import RealmSwift


class RealmHelper {
    static let defaultUrl = Realm.Configuration.defaultConfiguration.fileURL
    
    static func createRealm() -> Realm {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.inakase.Favs")!
        config.fileURL = url.appendingPathComponent("default.realm")
        return try! Realm(configuration: config)
    }
}
