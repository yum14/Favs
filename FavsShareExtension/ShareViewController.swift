//
//  ShareViewController.swift
//  FavsShareExtension
//
//  Created by yum on 2020/12/14.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    let suiteName: String = "group.com.inakase.Favs"
    let key: String = "shareData"
    
    // 文字入力されていないとPOSTを無効にする
    override func isContentValid() -> Bool {
        if !(self.contentText.count > 0) {
            return false
        }

        return true
    }
    
    override func didSelectPost() {
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        let puclicURL = String(kUTTypeURL)  // "public.url"
        
        // shareExtension で NSURL を取得
        if itemProvider.hasItemConformingToTypeIdentifier(puclicURL) {
            itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { (item, error) in
                // NSURLを取得する
                if let url: URL = item as? URL {
                    if let userDefaults = UserDefaults(suiteName: self.suiteName) {
                        
                        // すでに保存済みのデータを取得する
                        var data = {() -> [SharedFav] in
                            guard let sharedData = userDefaults.data(forKey: self.key) else {
                                return []
                            }
                            
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            guard let favs = try? jsonDecoder.decode([SharedFav].self, from: sharedData) else {
                                return []
                            }
                            return favs
                        }()
                        
                        // 入力された情報を追加し保存する
                        data.append(SharedFav(url: url, title: self.contentText))

                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
                        guard let encodeData = try? jsonEncoder.encode(data) else {
                            return
                        }

                        userDefaults.set(encodeData, forKey: self.key)
                    }
                }
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            })
        }
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
