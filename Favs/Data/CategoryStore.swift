//
//  CategoryStore.swift
//  Favs
//
//  Created by yum on 2020/10/31.
//

import Foundation
import RealmSwift
import UIKit

final class CategoryStore: ObservableObject {
    static let shared = CategoryStore()
    @Published var categoryList: List<FavCategory>
    private var notificationTokens: [NotificationToken] = []
    private var realmObject: FavCategories
    
    private init() {
        let realm = RealmHelper.createRealm()
        var categories = realm.object(ofType: FavCategories.self, forPrimaryKey: 0)
        if categories == nil {
            categories = try! realm.write{ realm.create(FavCategories.self, value: FavCategories())}
        }
        self.realmObject = categories!
        
        // freezeによってイミュータブルにしないとエラーになる
        self.categoryList = self.realmObject.categories.freeze()
        
        notificationTokens.append(self.realmObject.categories.observe { change in
            switch change {
            case let .initial(results):
                self.categoryList = results.freeze()
            case let .update(results, _, _, _):
                self.categoryList = results.freeze()
            case let .error(error):
                print(error.localizedDescription)
            }
        })
        
        // 初期データの追加
        addInitial()
    }
    
    public init(categories: [FavCategory]) {
        let list = List<FavCategory>()
        categories.forEach { list.append($0) }
        self.categoryList = list
        
        let realmObj = FavCategories()
        categories.forEach { realmObj.categories.append($0) }
        self.realmObject = realmObj
    }
    
    deinit {
        notificationTokens.forEach { $0.invalidate() }
    }
    
    private func addInitial() {
        if self.categoryList.first(where: { $0.isInitial }) == nil {
            add(name: "すべて", displayName: "すべて", isInitial: true)
        }
    }
    
    func add(id: String = "", name: String, displayName: String = "", isInitial: Bool = false) {
        let dt = Date()
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let newId = id.isEmpty ? UUID().uuidString : id
        let maxItem = self.realmObject.categories.max(by: { (a, b) in
            return a.order < b.order
        })
        let order = maxItem != nil ? maxItem!.order + 1 : 0
        let newDisplayName = displayName.isEmpty ? name : displayName
        
        let newCategory = FavCategory(id: newId, name: name, displayName: newDisplayName, isInitial: isInitial, order: order, createdAt: df.string(from: dt))
        
        add(newCategory)
    }
    
    func add(_ newCategory: FavCategory) {
        let realm = RealmHelper.createRealm()
        try! realm.write {
            self.realmObject.categories.append(newCategory)
        }
    }
    
    func delete(atOffsets: IndexSet) {
        let realm = RealmHelper.createRealm()
        try! realm.write {
            self.realmObject.categories.remove(atOffsets: atOffsets)
        }
    }
    
    func deleteAll() {
        let realm = RealmHelper.createRealm()
        try! realm.write {
            self.realmObject.categories.removeAll()
        }
    }
    
    func update(_ category: FavCategory) {
        let realm = RealmHelper.createRealm()
        guard let item = self.realmObject.categories.first(where: { $0.id == category.id }) else {
            return
        }
        
        try! realm.write {
            let dt = Date()
            let df = DateFormatter()
            df.locale = Locale(identifier: "ja_JP")
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = df.string(from: dt)
            
            item.name = category.name
            item.displayName = category.displayName
            item.isInitial = category.isInitial
            item.order = category.order
            item.createdAt = category.createdAt
            item.updatedAt = now
        }
    }
    
    func move(fromOffsets: IndexSet, toOffset: Int) {
        let realm = RealmHelper.createRealm()
        try! realm.write {
            self.realmObject.categories.move(fromOffsets: fromOffsets, toOffset: toOffset)
        }
    }
}

