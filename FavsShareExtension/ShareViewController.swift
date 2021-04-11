//
//  ShareViewController.swift
//  FavsShareExtension
//
//  Created by yum on 2020/12/14.
//

import UIKit
import Social
import RealmSwift
import MobileCoreServices

// TODO: いくつかのファイルをコピーして使っているが望ましくないので、そのうちEmbedded Framework導入を検討する
class ShareViewController: SLComposeServiceViewController, ListViewControllerDelegate {
    
    let suiteName: String = "group.com.inakase.Favs"
    let key: String = "shareData"
    var initialContentText: String = ""
    var items: [FavCategory] = []
    var selectedCategory: FavCategory?
    
    lazy var categoryItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()!
        item.title = "カテゴリ"
        item.value = items[0].displayName
        item.tapHandler = self.showLabelList
        return item
    }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.inakase.Favs")!
        config.fileURL = url.appendingPathComponent("default.realm")
        let realm = try! Realm(configuration: config)
        let realmObject = realm.object(ofType: FavCategories.self, forPrimaryKey: 0)
        
        guard let realmObj = realmObject, realmObj.categories.count > 0 else {
            self.items = [FavCategory(name: "すべて", displayName: "すべて", order: 0)]
            return
        }
        
        
        self.items = realmObj.categories.freeze().map { $0 }
        self.selectedCategory = items[0]
    }
    
    override func configurationItems() -> [Any]! {
        let items: [SLComposeSheetConfigurationItem] = [categoryItem]
        return items
    }
    
    func showLabelList() {
        let controller = ListViewController(style: .plain, itemList: self.items)
        controller.selectedValue = categoryItem.value
        controller.delegate  = self
        pushConfigurationViewController(controller)
    }
    
    // ListViewControllerのアイテム選択時のコールバックメソッド
    func listViewController(sender: ListViewController, selectedValue: FavCategory) {
        categoryItem.value = selectedValue.displayName
        self.selectedCategory = selectedValue
        popConfigurationViewController()
    }
    
    // 文字入力されていないとPOSTを無効にする
    override func isContentValid() -> Bool {
        if !(self.contentText.count > 0) {
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        
        // iOS13以降で高さがおかしいのを修正する
        if #available(iOS 13.0, *) {
            _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (_) in
                if let layoutContainerView = self.view.subviews.last {
                    layoutContainerView.frame.size.height += 15
                }
            }
        }
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
                let newFav = SharedFav(url: url, title: self.contentText, categoryId: self.selectedCategory?.id)
                self.addUserDefaults(newFav: newFav)
            }
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        })
    }

    private func handleUrl(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypeURL), options: nil, completionHandler: { (item, error) in
            if let url: URL = item as? URL {
                let newFav = SharedFav(url: url, title: self.contentText, categoryId: self.selectedCategory?.id)
                self.addUserDefaults(newFav: newFav)
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
    
}
