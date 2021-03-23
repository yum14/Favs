//
//  YoutubeVideoDataModel.swift
//  Favs
//
//  Created by yum on 2021/03/13.
//

import Foundation

class YoutubeVideoDataModel: WebAccessible {
    private static let scheme = "https"
    private static let host = ["www.youtube.com", "youtube.com"]
    private static let path = "/watch"
    private static let queryName = "v"
    private let baseUrl = "https://www.googleapis.com/youtube/v3/videos"
    private let part = "snippet"
    private var environmentStore: EnvironmentAccesible = EnvironmentStore.shared
    
    init() {}
    
    convenience init(environment: EnvironmentAccesible) {
        self.init()
        self.environmentStore = environment
    }
    
    static func isTarget(url: URL) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let scheme = components?.scheme, let host = components?.host, let path = components?.path, let queryItems = components?.queryItems else {
            return false
        }
        
        if !(scheme == self.scheme && self.host.contains(host) && path == self.path) {
            return false
        }
        
        guard let _ = queryItems.first(where: {$0.name == self.queryName}) else {
            return false
        }
        
        return true
    }
    
    func get(url: URL, completion: @escaping (PageInfo?, Error?) -> Void) throws -> Void {
        
        if !YoutubeVideoDataModel.isTarget(url: url) {
            return
        }
        
        let videoId = URLComponents(url: url, resolvingAgainstBaseURL: true)!.queryItems!.first(where: {$0.name == YoutubeVideoDataModel.queryName})!.value
        
        var components = URLComponents(string: self.baseUrl)!
        components.queryItems = [URLQueryItem(name: "key", value: self.environmentStore.config!.youtubeDataApi!.apikey),
                                 URLQueryItem(name: "id", value: videoId),
                                 URLQueryItem(name: "part", value: self.part)]
        
        let task = URLSession.shared.dataTask(with: components.url!) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.sync {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let videoData = try decoder.decode(YoutubeVideo.self, from: data)
                    let pageInfo = self.mapPageInfo(url: url, data: videoData)
                    completion(pageInfo, nil)
                } catch let error {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    private func mapPageInfo(url: URL, data: YoutubeVideo) -> PageInfo {
        let snippet = data.items[0].snippet!
        let pageInfo = PageInfo(url: url.absoluteString, dispTitle: snippet.title, dispDescription: snippet.description, imageUrl: snippet.thumbnails.standard?.url ?? "")
        
        return pageInfo
    }
}
