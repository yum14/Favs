//
//  PageInfoObserver.swift
//  Favs
//
//  Created by yum on 2021/03/13.
//

import Foundation

class PageInfoObserver: ObservableObject {
    @Published var pageInfo: PageInfo?
    @Published var isLoading: Bool
    
    private let selector: WebAccessSelector
    
    init(selector: WebAccessSelector) {
        self.isLoading = false
        self.selector = selector
    }

    func get(url: URL, completion argCompletion: @escaping (PageInfo?, Error?) -> Void = {(_,_) in return}) -> Void {
        self.isLoading = true
        
        let completion = {(pageInfo: PageInfo?, error: Error?) -> Void in
            if let error = error {
                print(error)
            }
            self.pageInfo = pageInfo ?? PageInfo()
            self.isLoading = false
            
            argCompletion(pageInfo ?? PageInfo(), error)
        }
 
        do {
            try self.selector.getInstance(url: url).get(url: url, completion: completion)
        } catch let error {
            print(error)
            self.pageInfo = nil
            self.isLoading = false
        }
    }
}
