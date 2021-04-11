//
//  ViewState.swift
//  Favs
//
//  Created by yum on 2021/01/17.
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
    
    convenience init(id: Int = 0,
                     category: String = "",
                     displayMode: String = "",
                     createdAt: String = "",
                     updatedAt: String = "") {
        self.init()
        
        self.id = id
        self.category = category
        self.displayMode = displayMode
        self.createdAt = createdAt
        self.updatedAt = updatedAt        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy() -> ViewState {
        return ViewState(id: self.id, category: self.category, displayMode: self.displayMode, createdAt: self.createdAt, updatedAt: self.updatedAt)
    }
}
