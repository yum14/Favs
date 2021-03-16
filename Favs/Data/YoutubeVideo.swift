//
//  YoutubeVideo.swift
//  Favs
//
//  Created by yum on 2021/03/13.
//

import Foundation

struct YoutubeVideo: Codable {
    var kind: String
    var etag: String
    var items: [YoutubeVideoItem]
}

struct YoutubeVideoItem: Codable {
    var id: String
    var snippet: YoutubeVideoSnippet?
}

struct YoutubeVideoSnippet: Codable {
    var channelId: String
    var title: String
    var description: String
    var thumbnails: YoutubeVideoThumbnails
}

struct YoutubeVideoThumbnails: Codable {
    var def: YoutubeVideoThumbnail?
    var medium: YoutubeVideoThumbnail?
    var high: YoutubeVideoThumbnail?
    var standard: YoutubeVideoThumbnail?
    var maxres: YoutubeVideoThumbnail?

    private enum CodingKeys: String, CodingKey {
        case def = "default"
        case medium = "medium"
        case high = "high"
        case standard = "standard"
        case maxres = "maxres"
    }
}

struct YoutubeVideoThumbnail: Codable {
    var url: String
    var width: Int?
    var height: Int?
}
