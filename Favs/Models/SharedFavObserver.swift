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
    private let pageInfoObserver = PageInfoObserver(selector: WebAccessSelector())
    
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
                let completion = { (pageInfo: PageInfo?, error: Error?) in
                    if let pageInfo = pageInfo {
                        self.favStore.add(url: item.url.absoluteString,
                                          category: self.categoryStore.categoryList.first(where: {$0.isInitial})!.id,
                                          comment: "",
                                          dispTitle: YoutubeVideoDataModel.isTarget(url: item.url) && item.url.absoluteString == item.title ? pageInfo.dispTitle : item.title,
                                          dispDescription: pageInfo.dispDescription,
                                          imageUrl: pageInfo.imageUrl,
                                          titleOnHeader: pageInfo.titleOnHeader,
                                          ogTitle: pageInfo.ogTitle,
                                          ogDescription: pageInfo.ogDescription,
                                          ogType: pageInfo.ogType,
                                          ogUrl: pageInfo.ogUrl,
                                          ogImage: pageInfo.ogImage,
                                          fbAppId: pageInfo.fbAppId,
                                          twitterCard: pageInfo.twitterCard,
                                          twitterSite: pageInfo.twitterSite,
                                          twitterCreator: pageInfo.twitterCreator,
                                          descriptionOnHeader: pageInfo.descriptionOnHeader,
                                          thumbnail: pageInfo.thumbnail)
                    } else {
                        self.favStore.add(url: item.url.absoluteString,
                                          category: self.categoryStore.categoryList.first(where: {$0.isInitial})!.id,
                                          comment: "",
                                          dispTitle: item.title)
                    }
                }
                
                // webページ情報の取得
                self.pageInfoObserver.get(url: item.url, completion: completion)
            }
            
            // 読み込んだら現在の値を消す
            userDefaults?.removeObject(forKey: key)
        }
    }
    
    deinit {
        userDefaults!.removeObserver(self, forKeyPath: key)
    }
}
