//
//  FavsApp.swift
//  Favs
//
//  Created by ゆう on 2020/10/15.
//

import SwiftUI

@main
struct FavsApp: App {
//    let favStore = FavStore.shared
    let categoryStore = CategoryStore.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    if categoryStore.categoryList.first(where: { $0.isInitial }) == nil {
                        categoryStore.add(FavCategory(name: "すべて", displayName: "すべて", isInitial: true, order: 0))
                    }
                }
        }
    }
}
