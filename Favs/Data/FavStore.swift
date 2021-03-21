//
//  FavStore.swift
//  Favs
//
//  Created by yum on 2020/11/01.
//

import Foundation
import RealmSwift

final class FavStore: ObservableObject {
    static let shared = FavStore()
    @Published var favs: List<Fav>
    private var notificationTokens: [NotificationToken] = []
    private var realmObject: Favs
    
    // breakして po Realm.Configuration.defaultConfiguration.fileURL! でファイルの場所を確認。
    // 該当のフォルダのファイルをすべて削除。 rm -rf *
    private init() {
        let realm = try! Realm()
        var favs = realm.object(ofType: Favs.self, forPrimaryKey: 0)
        if favs == nil {
            favs = try! realm.write{ realm.create(Favs.self, value: Favs())}
        }
        self.realmObject = favs!
        
        // freezeによってイミュータブルにしないとエラーになる
        self.favs = self.realmObject.favs.freeze()
        
        notificationTokens.append(self.realmObject.favs.observe { change in
            switch change {
            case let .initial(results):
                self.favs = results.freeze()
            case let .update(results, _, _, _):
                self.favs = results.freeze()
            case let .error(error):
                print(error.localizedDescription)
            }
        })
    }
    
    
    public init(favs: [Fav]) {
        let list = List<Fav>()
        favs.forEach { list.append($0) }
        self.favs = list
        
        let realmObj = Favs()
        favs.forEach { realmObj.favs.append($0) }
        self.realmObject = realmObj
    }
    
    deinit {
        notificationTokens.forEach { $0.invalidate() }
    }
    
    func add(id: String = "",
             url: String,
             category: String = "",
             comment: String = "",
             dispTitle: String = "",
             dispDescription: String = "",
             imageUrl: String = "",
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
             thumbnail: String = "") {
        
        let dt = Date()
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let maxItem = self.realmObject.favs.max(by: { $0.order < $1.order })
        let order = maxItem != nil ? maxItem!.order + 1 : 0
        
        let newFav = Fav(id: id.isEmpty ? UUID().uuidString : id,
                         url: url,
                         order: order,
                         category: category,
                         comment: comment,
                         dispTitle: dispTitle,
                         dispDescription: dispDescription,
                         imageUrl: imageUrl,
                         titleOnHeader: titleOnHeader,
                         ogTitle: ogTitle,
                         ogDescription: ogDescription,
                         ogType: ogType,
                         ogUrl: ogUrl,
                         ogImage: ogImage,
                         fbAppId: fbAppId,
                         twitterCard: twitterCard,
                         twitterSite: twitterSite,
                         twitterCreator: twitterCreator,
                         descriptionOnHeader: descriptionOnHeader,
                         thumbnail: thumbnail,
                         createdAt: df.string(from: dt),
                         updatedAt: "")
        
        let realm = try! Realm()
        try! realm.write {
            self.realmObject.favs.append(newFav)
        }
    }
    
    func delete(atOffsets: IndexSet) {
        let realm = try! Realm()
        try! realm.write {
            self.realmObject.favs.remove(atOffsets: atOffsets)
        }
    }
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            self.realmObject.favs.removeAll()
        }
    }
    
    func update(id: String,
                url: String? = nil,
                order: Int? = nil,
                category: String? = nil,
                comment: String? = nil,
                dispTitle: String? = nil,
                dispDescription: String? = nil,
                imageUrl: String? = nil,
                titleOnHeader: String? = nil,
                ogTitle: String? = nil,
                ogDescription: String? = nil,
                ogType: String? = nil,
                ogUrl: String? = nil,
                ogImage: String? = nil,
                fbAppId: String? = nil,
                twitterCard: String? = nil,
                twitterSite: String? = nil,
                twitterCreator: String? = nil,
                descriptionOnHeader: String? = nil,
                thumbnail: String? = nil) {
        
        guard let item = self.realmObject.favs.first(where: { $0.id == id }) else {
            return
        }
        
        let dt = Date()
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = df.string(from: dt)
        
        let realm = try! Realm()
        try! realm.write {
            if let url = url { item.url = url }
            if let order = order { item.order = order }
            if let category = category {    item.category = category }
            if let comment = comment { item.comment = comment }
            if let dispTitle = dispTitle { item.dispTitle = dispTitle }
            if let dispDescription = dispDescription { item.dispDescription = dispDescription }
            if let imageUrl = imageUrl { item.imageUrl = imageUrl }
            if let titleOnHeader = titleOnHeader { item.titleOnHeader = titleOnHeader }
            if let ogTitle = ogTitle { item.ogTitle = ogTitle }
            if let ogDescription = ogDescription { item.ogDescription = ogDescription }
            if let ogType = ogType { item.ogType = ogType }
            if let ogUrl = ogUrl { item.ogUrl = ogUrl }
            if let ogImage = ogImage { item.ogImage = ogImage }
            if let fbAppId = fbAppId { item.fbAppId = fbAppId }
            if let twitterCard = twitterCard { item.twitterCard = twitterCard }
            if let twitterSite = twitterSite { item.twitterSite = twitterSite }
            if let twitterCreator = twitterCreator { item.twitterCreator = twitterCreator }
            if let descriptionOnHeader = descriptionOnHeader { item.descriptionOnHeader = descriptionOnHeader }
            item.updatedAt = now
        }
    }
    
    func move(fromOffsets: IndexSet, toOffset: Int) {
        let realm = try! Realm()
        try! realm.write {
            self.realmObject.favs.move(fromOffsets: fromOffsets, toOffset: toOffset)
        }
    }
}



