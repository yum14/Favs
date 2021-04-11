//
//  Fav.swift
//  FavsShareExtension
//
//  Created by yum on 2020/12/14.
//

import Foundation

struct SharedFav: Equatable, Codable {
    let url: URL
    let title: String
    let categoryId: String?
}
