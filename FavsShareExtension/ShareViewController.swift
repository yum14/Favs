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
    var initialContentText: String = ""
    
    // 文字入力されていないとPOSTを無効にする
    override func isContentValid() -> Bool {
        if !(self.contentText.count > 0) {
            return false
        }
        
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // youtubeの場合はPlainTextでURLが設定されるため保持しておく
        self.initialContentText = self.contentText
    }
    
    override func didSelectPost() {
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        guard let itemProvider = extensionItem.attachments?.first else {
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypeURL)) {
            self.handleUrl(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePlainText)) {
            // youtubeはplainTextの模様
            self.handlePlainText(itemProvider: itemProvider)
        }
        
    }
    
    private func handlePlainText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypePlainText), options: nil, completionHandler: { (item, error) in
            if let url = URL(string: self.initialContentText) {
                self.addUserDefaults(newFav: SharedFav(url: url, title: self.contentText))
            }
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        })
    }

    private func handleUrl(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypeURL), options: nil, completionHandler: { (item, error) in
            if let url: URL = item as? URL {
                self.addUserDefaults(newFav: SharedFav(url: url, title: self.contentText))
            }
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        })
    }
    
    private func addUserDefaults(newFav: SharedFav) {
        if let userDefaults = UserDefaults(suiteName: self.suiteName) {
            
            var data = self.getSavedFavs(userDefaults: userDefaults)
            data.append(newFav)
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            guard let encodeData = try? jsonEncoder.encode(data) else {
                return
            }
            
            userDefaults.set(encodeData, forKey: self.key)
        }
    }
    
    private func getSavedFavs(userDefaults: UserDefaults) -> [SharedFav] {
        guard let sharedData = userDefaults.data(forKey: self.key) else {
            return []
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let favs = try? jsonDecoder.decode([SharedFav].self, from: sharedData) else {
            return []
        }
        return favs
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
}
