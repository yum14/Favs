//
//  ViewStateStore.swift
//  Favs
//
//  Created by ゆう on 2021/01/17.
//

import Foundation
import RealmSwift

final class ViewStateStore: NSObject, ObservableObject {
    static let shared = ViewStateStore()
    private var viewState: ViewState

    // breakして po Realm.Configuration.defaultConfiguration.fileURL! でファイルの場所を確認。
    // /Users/yumurata/Library/Developer/CoreSimulator/Devices/434C1063-4104-4B45-9912-B02C2BAF0622/data/Containers/Data/Application/4135D260-4190-4E6F-AFDE-5B551525D406/Documents/
    // 該当のフォルダのファイルをすべて削除。 rm -rf *
    private override init() {
        
        let realm = try! Realm()
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
        let realm = try! Realm()
        
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

