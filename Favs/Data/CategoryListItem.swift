//
//  CategoryListItem.swift
//  Favs
//
//  Created by yum on 2020/12/30.
//

import Foundation

class CategoryListItem: Identifiable {
    var id: String = ""
    var displayName: String = ""
    
    init(id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
    }
}
