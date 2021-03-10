//
//  Fav.swift
//  Favs
//
//  Created by yum on 2020/10/16.
//

import Foundation
import RealmSwift

class Fav: Object, Identifiable {
    @objc dynamic var id: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var order: Int = 0
    @objc dynamic var category: String = ""
    @objc dynamic var comment: String = ""
    @objc dynamic var dispTitle: String = ""
    @objc dynamic var dispDescription: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var titleOnHeader: String = ""
    @objc dynamic var ogTitle: String = ""
    @objc dynamic var ogDescription: String = ""
    @objc dynamic var ogType: String = ""
    @objc dynamic var ogUrl: String = ""
    @objc dynamic var ogImage: String = ""
    @objc dynamic var fbAppId: String = ""
    @objc dynamic var twitterCard: String = ""
    @objc dynamic var twitterSite: String = ""
    @objc dynamic var twitterCreator: String = ""
    @objc dynamic var descriptionOnHeader: String = ""
    @objc dynamic var thumbnail: String = ""

    @objc dynamic var createdAt: String = ""
    @objc dynamic var updatedAt: String = ""
    
    override init() {}
    
    convenience init(id: String,
                     url: String,
                     order: Int,
                     category: String = "",
                     comment: String = "",
                     dispTitle: String,
                     dispDescription: String = "",
                     imageUrl: String,
                     titleOnHeader: String = "",
                     ogTitle: String = "",
                     ogDescription: String = "",
                     ogType: String = "",
                     ogUrl: String = "",
                     ogImage: String = "",
                     fbAppId: String = "",
                     twitterCard: String = "",
                     twitterSite: String = "",
                     twitterCreator: String = "",
                     descriptionOnHeader: String = "",
                     thumbnail: String = "",
                     createdAt: String = "",
                     updatedAt: String = "") {
        self.init()

        self.id = id
        self.url = url
        self.order = order
        self.category = category
        self.comment = comment
        self.dispTitle = dispTitle
        self.dispDescription = dispDescription
        self.imageUrl = imageUrl
        self.titleOnHeader = titleOnHeader
        self.ogTitle = ogTitle
        self.ogDescription = ogDescription
        self.ogType = ogType
        self.ogUrl = ogUrl
        self.ogImage = ogImage
        self.fbAppId = fbAppId
        self.twitterCard = twitterCard
        self.twitterSite = twitterSite
        self.twitterCreator = twitterCreator
        self.descriptionOnHeader = descriptionOnHeader
        self.thumbnail = thumbnail
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
