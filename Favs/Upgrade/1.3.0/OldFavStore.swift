//
//  OldFavStore.swift
//  Favs
//
//  Created by yum on 2021/04/08.
//

import Foundation
import RealmSwift

class OldFavStore {
    private var favs: [Fav]
    
    init() {
        let realm = try! Realm()
        let realmObject = realm.object(ofType: Favs.self, forPrimaryKey: 0)
        if let realmObject = realmObject {
            self.favs = realmObject.favs.freeze().map { $0 }
        } else {
            self.favs = []
        }
    }
    
    func get() -> [Fav] {
        return self.favs.map { $0 }
    }
}
