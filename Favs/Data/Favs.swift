//
//  Favs.swift
//  Favs
//
//  Created by yum on 2020/11/01.
//

import Foundation
import RealmSwift

class Favs: Object {
    @objc dynamic var id: Int = 0
    let favs = List<Fav>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
