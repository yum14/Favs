//
//  PageInfoAccessible.swift
//  Favs
//
//  Created by yum on 2021/03/13.
//

import Foundation

protocol WebAccessible {
    func get(url: URL, completion: @escaping (PageInfo?, Error?) -> Void) throws -> Void
}
