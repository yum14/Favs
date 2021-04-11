//
//  OldViewStateStore.swift
//  Favs
//
//  Created by yum on 2021/04/08.
//

import Foundation
import RealmSwift

class OldViewStateStore {
    private var viewState: ViewState?

    init() {
        let realm = try! Realm()
        let realmObject = realm.object(ofType: ViewState.self, forPrimaryKey: 0)
        if let realmObject = realmObject {
            self.viewState = realmObject.freeze()
        }
    }
    
    func get() -> ViewState? {
        return self.viewState
    }
}
