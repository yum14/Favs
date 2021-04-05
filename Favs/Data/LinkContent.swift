//
//  LinkContent.swift
//  Favs
//
//  Created by yum on 2021/04/04.
//

import Foundation

class LinkContent: Identifiable {
    var id: String
    var url: String
    var title: String
    var imageUrl: String

    init(id: String = "", url: String = "", title: String = "", imageUrl: String = "") {
        self.id = id
        self.url = url
        self.title = title
        self.imageUrl = imageUrl
    }
}
