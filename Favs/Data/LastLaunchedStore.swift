//
//  LastLaunchedStore.swift
//  Favs
//
//  Created by yum on 2021/04/08.
//

import Foundation
import RealmSwift

final class LastLaunchedStore: NSObject, ObservableObject {
    static let shared = LastLaunchedStore()
    private var lastLaunched: LastLaunched

    private override init() {
        let realm = RealmHelper.createRealm()
        
        var lastLaunched = realm.object(ofType: LastLaunched.self, forPrimaryKey: 0)
        if lastLaunched == nil {
            lastLaunched = try! realm.write{
                realm.create(LastLaunched.self, value: LastLaunched(createdAt: LastLaunchedStore.getNowString()))
            }
        }

        self.lastLaunched = lastLaunched!
        super.init()
    }
    
    func get() -> LastLaunched {
        return self.lastLaunched
    }

    func update(_ lastLaunched: LastLaunched) {
        let realm = RealmHelper.createRealm()
        
        try! realm.write {
            self.lastLaunched.version = lastLaunched.version
            self.lastLaunched.createdAt = lastLaunched.createdAt
            self.lastLaunched.updatedAt = LastLaunchedStore.getNowString()
        }
    }
    
    static func getNowString() -> String {
        let dt = Date()
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: dt)
    }
}
