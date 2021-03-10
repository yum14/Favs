//
//  ShareFavStore.swift
//  Favs
//
//  Created by yum on 2020/12/15.
//

import Foundation

class SharedFavObserver: NSObject {
    private let userDefaults = UserDefaults(suiteName: "group.com.inakase.Favs")
    private let key: String = "shareData"
    private let favStore = FavStore.shared
    private let categoryStore = CategoryStore.shared
    private let webPageModel = WebPageModel()
    
    override init() {
        super.init()
        userDefaults!.addObserver(self, forKeyPath: self.key, options: NSKeyValueObservingOptions.new, context: nil)
        
        addFav()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        addFav()
    }
    
    private func addFav() {
        if let sharedData = userDefaults?.data(forKey: key) { 
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let sharedFavs = try? jsonDecoder.decode([SharedFav].self, from: sharedData) else {
                return
            }
            
            for item in sharedFavs {
                let completion = { (pageInfo: PageInfo) in
                    if !(pageInfo.url.count > 0) {
                        return
                    }
                
                    self.favStore.add(url: item.url.absoluteString,
                                      category: self.categoryStore.categoryList.first(where: {$0.isInitial})!.id,
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
                webPageModel.getPage(url: item.url, completion: completion)
            }
            
            // 読み込んだら現在の値を消す
            userDefaults?.removeObject(forKey: key)
        }
    }

    deinit {
      userDefaults!.removeObserver(self, forKeyPath: key)
    }
}
