//
//  LastLaunched.swift
//  Favs
//
//  Created by yum on 2021/04/08.
//

import Foundation
import RealmSwift

class LastLaunched: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var version: String = ""
    @objc dynamic var createdAt: String = ""
    @objc dynamic var updatedAt: String = ""
    
    override init() {}
    
    convenience init(version: String = "",
                     createdAt: String = "",
                     updatedAt: String = "") {
        self.init()
        
        self.version = version
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
