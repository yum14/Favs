//
//  ShareFavStore.swift
//  Favs
//
//  Created by ゆう on 2020/12/15.
//

import Foundation

class SharedFavObserver: NSObject {
//    static let shared = SharedFavStore()
    private let userDefaults = UserDefaults(suiteName: "group.com.inakase.Favs")
    private let key: String = "shareData"
    private let favStore = FavStore.shared
    private let categoryStore = CategoryStore.shared
    
    private let webPageModel = WebPageModel()
    
//    @Published var sharedFav: SharedFav?
    
    override init() {
        super.init()
        userDefaults!.addObserver(self, forKeyPath: self.key, options: NSKeyValueObservingOptions.new, context: nil)
        
        addFav()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        addFav()
    }
    
    func addFav() {
        if let sharedData = userDefaults?.data(forKey: key) {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let sharedFav = try? jsonDecoder.decode(SharedFav.self, from: sharedData) else {
                return
            }
            
            let completion = { (pageInfo: PageInfo) in
                
                if !(pageInfo.url.count > 0) {
                    return
                }
            
                // TODO: 仮で"カテゴリなし"にしている
                self.favStore.add(url: sharedFav.url.absoluteString,
                                  category: "",
                                  comment: "",
                                  dispTitle: self.webPageModel.pageInfo.dispTitle,
                                  dispDescription: self.webPageModel.pageInfo.dispDescription,
                                  imageUrl: self.webPageModel.pageInfo.imageUrl,
                                  titleOnHeader: self.webPageModel.pageInfo.titleOnHeader,
                                  ogTitle: self.webPageModel.pageInfo.ogTitle,
                                  ogDescription: self.webPageModel.pageInfo.ogDescription,
                                  ogType: self.webPageModel.pageInfo.ogType,
                                  ogUrl: self.webPageModel.pageInfo.ogUrl,
                                  ogImage: self.webPageModel.pageInfo.ogImage,
                                  fbAppId: self.webPageModel.pageInfo.fbAppId,
                                  twitterCard: self.webPageModel.pageInfo.twitterCard,
                                  twitterSite: self.webPageModel.pageInfo.twitterSite,
                                  twitterCreator: self.webPageModel.pageInfo.twitterCreator,
                                  descriptionOnHeader: self.webPageModel.pageInfo.descriptionOnHeader,
                                  thumbnail: self.webPageModel.pageInfo.thumbnail)
            }
            
            // webページ情報の取得
            webPageModel.getPage(url: sharedFav.url, completion: completion)
            
            // 読み込んだら現在の値を消す
            userDefaults?.removeObject(forKey: key)
        }
    }

    deinit {
      userDefaults!.removeObserver(self, forKeyPath: key)
    }
}
