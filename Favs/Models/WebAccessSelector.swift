//
//  WebAccessSelector.swift
//  Favs
//
//  Created by yum on 2021/03/13.
//

import Foundation

class WebAccessSelector {
    private let youtubeModel = YoutubeVideoDataModel()
    private let webPageModel = WebPageModel()
    
    func getInstance(url: URL) -> WebAccessible {

        if YoutubeVideoDataModel.isTarget(url: url) {
            return self.youtubeModel
        }
        
        return self.webPageModel
    }
}
