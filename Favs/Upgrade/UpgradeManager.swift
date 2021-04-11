//
//  UpgradeManager.swift
//  Favs
//
//  Created by yum on 2021/04/09.
//

import Foundation

class UpgradeManager {
    private let lastLaunchedStore = LastLaunchedStore.shared
    
    func upgrade() {
        
        // 前回App起動時のバージョン取得
        let lastLaunched = self.lastLaunchedStore.get()
        
        // 1.3.0 バージョンアップ
        if lastLaunched.version.isEmpty || compareVersion(version1: lastLaunched.version, version2: "1.3.0") {
            let migration = MigrationToGroupDatabase()
            migration.migrate()
        }
        
        // バージョン更新
        let newLaunchedVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        if lastLaunched.version != newLaunchedVersion {
            lastLaunchedStore.update(LastLaunched(version: newLaunchedVersion, createdAt: lastLaunched.createdAt))
        }
    }

    func compareVersion(version1: String, version2: String) -> Bool {
        
        let version1arr = version1.split(separator: ".")
        let version2arr = version2.split(separator: ".")
        
        let count = max(version1arr.count, version2arr.count)
        
        for i in 0 ..< count {
            let version1Int = Int(version1arr.count > i ? version1arr[i] : "0") ?? 0
            let version2Int = Int(version2arr.count > i ? version2arr[i] : "0") ?? 0
            
            if version1Int < version2Int {
                return true
            }
        }
        
       return false
    }
}
