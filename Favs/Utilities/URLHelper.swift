//
//  UrlHelper.swift
//  Favs
//
//  Created by yum on 2020/11/07.
//

import Foundation

class URLHelper {
    static func getDomain(_ url: String) -> String {
        guard let target = URL(string: url), let host = target.host else {
            return url
        }
        
        return host
    }
}
