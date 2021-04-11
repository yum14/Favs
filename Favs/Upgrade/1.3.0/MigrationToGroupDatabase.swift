//
//  Migration.swift
//  Favs
//
//  Created by yum on 2021/04/08.
//

import Foundation
import RealmSwift

class MigrationToGroupDatabase {
    private let oldFavStore: OldFavStore
    private let oldCategoryStore: OldCategoryStore
    private let oldViewStateStore: OldViewStateStore
    
    private var favStore = FavStore.shared
    private var categoryStore = CategoryStore.shared
    private let viewStateStore = ViewStateStore.shared
    
    init() {
        self.oldFavStore = OldFavStore()
        self.oldCategoryStore = OldCategoryStore()
        self.oldViewStateStore = OldViewStateStore()
    }
    
    func migrate() {
        migrateCategories()
        migrateFavs()
        migrateViewState()
    }
    
    private func migrateCategories() {
        let oldCategories = self.oldCategoryStore.get().filter({ !$0.isInitial })
        
        for oldCategory in oldCategories {
            self.categoryStore.add(oldCategory.copy())
        }
    }
    
    private func migrateFavs() {
        let oldFavs = self.oldFavStore.get()
        
        for oldFav in oldFavs {
            self.favStore.add(oldFav.copy())
        }
    }
    
    private func migrateViewState() {
        if let oldViewState = self.oldViewStateStore.get() {
            self.viewStateStore.update(oldViewState.copy())
        }
    }
}
