//
//  Categories.swift
//  Favs
//
//  Created by yum on 2020/10/31.
//

import Foundation
import RealmSwift

class FavCategories: Object {
    @objc dynamic var id: Int = 0
    let categories = List<FavCategory>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
