//
//  WebPageHttpClient.swift
//  Favs
//
//  Created by yum on 2020/11/04.
//

import Foundation
import Kanna

class WebPageModel: ObservableObject, WebAccessible {
    
    func get(url: URL, completion: @escaping (PageInfo?, Error?) -> Void) throws -> Void {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                // httpは通らない。info.plistのNSAllowsArbitraryLoadsをyesとすれば通せるようだがどうするか。
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            do {
                try DispatchQueue.main.sync {
                    let htmlString = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .shiftJIS) ?? nil
                    let doc = try HTML(html: htmlString!, encoding: .utf8)
                    var pageInfo = self.htmlParse(url: url, doc: doc)
                    pageInfo.dispTitle = !pageInfo.ogTitle.isEmpty ? pageInfo.ogTitle : pageInfo.titleOnHeader
                    pageInfo.dispDescription = !pageInfo.ogDescription.isEmpty ? pageInfo.ogDescription : pageInfo.descriptionOnHeader
                    pageInfo.imageUrl = !pageInfo.ogImage.isEmpty ? pageInfo.ogImage : pageInfo.thumbnail
                    completion(pageInfo, nil)
                }
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    private func htmlParse(url: URL, doc: HTMLDocument) -> PageInfo {
        var pageInfo = PageInfo(url: url.absoluteString)
        
        if let title = doc.title {
            pageInfo.titleOnHeader = title
        }
        
        let metatags = doc.css("meta")
        metatags.forEach({ xmlelement in
            let prop = xmlelement["property"]
            let name = xmlelement["name"]
            let content = xmlelement["content"]
            
            if let prop = prop, let content = content {
                switch prop {
                case "og:title":
                    pageInfo.ogTitle = content
                case "og:description":
                    pageInfo.ogDescription = content
                case "og:type":
                    pageInfo.ogType = content
                case "og:url":
                    pageInfo.ogUrl = content
                case "og:image":
                    pageInfo.ogImage = content
                case "fb:app_id":
                    pageInfo.fbAppId = content
                default: break
                }
            }
            
            if let name = name, let content = content {
                switch name {
                case "description":
                    pageInfo.descriptionOnHeader = content
                case "thumbnail":
                    pageInfo.thumbnail = content
                case "twitter:card":
                    pageInfo.twitterCard = content
                case "twitter:site":
                    pageInfo.twitterSite = content
                case "twitter:creator":
                    pageInfo.twitterCreator = content
                default: break
                }
            }
        })
        
        return pageInfo
    }
}
