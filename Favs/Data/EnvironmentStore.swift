//
//  EnvironmentStore.swift
//  Favs
//
//  Created by yum on 2021/03/13.
//

import Foundation

protocol EnvironmentAccesible {
    var config: EnvironmentItem? { get }
}

final class EnvironmentStore: EnvironmentAccesible {
    var config: EnvironmentItem?
    static let shared = EnvironmentStore()
    
    private var fileName: String = ".env"
    private var type: EnvironmentType = EnvironmentType.production
    
    private init() {
        guard let path = Bundle.main.path(forResource: self.fileName, ofType: nil) else {
            return
        }
        
        #if DEBUG
        self.type = .development
        #endif
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let env = try! decoder.decode(EnvironmentData.self, from: data)
        
        self.config = {() -> EnvironmentItem? in
            switch self.type {
            case .production:
                return env.production
            case .staging:
                return env.staging
            case .development:
                return env.development
            }
        }()
    }
}

enum EnvironmentType {
    case production
    case development
    case staging
}
