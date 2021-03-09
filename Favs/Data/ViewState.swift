//
//  ViewState.swift
//  Favs
//
//  Created by ゆう on 2021/01/17.
//

import Foundation
import RealmSwift

class ViewState: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var category: String = ""
    @objc dynamic var displayMode: String = ""
    @objc dynamic var createdAt: String = ""
    @objc dynamic var updatedAt: String = ""
    
    override init() {}
    
    convenience init(category: String = "",
                     displayMode: String = "",
                     createdAt: String = "",
                     updatedAt: String = "") {
        self.init()
        
        self.category = category
        self.displayMode = displayMode
        self.createdAt = createdAt
        self.updatedAt = updatedAt        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
