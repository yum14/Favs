//
//  OldCategoryStore.swift
//  Favs
//
//  Created by yum on 2021/04/07.
//

import Foundation
import RealmSwift

class OldCategoryStore {
    private var categories: [FavCategory]
    
    init() {
        let realm = try! Realm()
        let realmObject = realm.object(ofType: FavCategories.self, forPrimaryKey: 0)
        if let realmObject = realmObject {
            // freezeによってイミュータブルにしないとエラーになる
            self.categories = realmObject.categories.freeze().map { $0 }
        } else {
            self.categories = []
        }
    }
    
    func get() -> [FavCategory] {
        return self.categories.map { $0 }
    }
}
