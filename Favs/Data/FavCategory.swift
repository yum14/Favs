//
//  Category.swift
//  Favs
//
//  Created by yum on 2020/10/18.
//

import Foundation
import RealmSwift

class FavCategory: Object, Identifiable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var displayName: String = ""
    @objc dynamic var order: Int = 0
    @objc dynamic var isInitial: Bool = false
    @objc dynamic var createdAt: String = ""
    @objc dynamic var updatedAt: String = ""
    
    override init() {
    }
    
    convenience init(id: String = "", name: String, displayName: String = "", isInitial: Bool = false, order: Int, createdAt: String = "", updatedAt: String = "") {
        self.init()
        
        if id.isEmpty {
            self.id = UUID().uuidString
        } else {
            self.id = id
        }
        
        self.name = name
        self.displayName = displayName
        self.order = order
        self.isInitial = isInitial
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy() -> FavCategory {
        return FavCategory(id: self.id, name: self.name, displayName: self.displayName, isInitial: self.isInitial, order: self.order, createdAt: self.createdAt, updatedAt: self.updatedAt)
    }
}
