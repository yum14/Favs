//
//  EnvironmentData.swift
//  Favs
//
//  Created by yum on 2021/03/13.
//

import Foundation

struct EnvironmentData: Codable {
    let production: EnvironmentItem?
    let staging: EnvironmentItem?
    let development: EnvironmentItem?
}

struct EnvironmentItem: Codable {
    let youtubeDataApi: EnvironmentYoutubeDataApi?
}

struct EnvironmentYoutubeDataApi: Codable {
    let apikey: String
}
