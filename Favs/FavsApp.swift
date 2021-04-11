//
//  FavsApp.swift
//  Favs
//
//  Created by yum on 2020/10/15.
//

import SwiftUI

@main
struct FavsApp: App {
    let upgradeManager = UpgradeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // アップグレード
                    self.upgradeManager.upgrade()
                }
        }
    }
}
