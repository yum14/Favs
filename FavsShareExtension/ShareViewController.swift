//
//  ShareViewController.swift
//  FavsShareExtension
//
//  Created by ゆう on 2020/12/14.
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
                    // 保存処理
                    
                    let fav = SharedFav(url: url, title: self.contentText)

                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
                    guard let data = try? jsonEncoder.encode(fav) else {
                        return
                    }

                    let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
                    sharedDefaults.set(data, forKey: self.key)
                    
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
