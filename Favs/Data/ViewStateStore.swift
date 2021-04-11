//
//  ViewStateStore.swift
//  Favs
//
//  Created by yum on 2021/01/17.
//

import Foundation
import RealmSwift

final class ViewStateStore: NSObject, ObservableObject {
    static let shared = ViewStateStore()
    private var viewState: ViewState

    private override init() {
        let realm = RealmHelper.createRealm()
        var viewState = realm.object(ofType: ViewState.self, forPrimaryKey: 0)
        if viewState == nil {
            viewState = try! realm.write{ realm.create(ViewState.self, value: ViewState())}
        }
        self.viewState = viewState!
        super.init()
    }
    
    func get() -> ViewState {
        return self.viewState
    }

    func update(_ viewState: ViewState) {
        let realm = RealmHelper.createRealm()
        
        try! realm.write {
            let dt = Date()
            let df = DateFormatter()
            df.locale = Locale(identifier: "ja_JP")
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = df.string(from: dt)
            
            self.viewState.category = viewState.category
            self.viewState.displayMode = viewState.displayMode
            self.viewState.createdAt = viewState.createdAt
            self.viewState.updatedAt = now
        }
    }
}

