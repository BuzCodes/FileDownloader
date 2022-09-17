//
//  Types.swift
//  URLSessionExtension
//
//  Created by Alessandro Loi on 04/10/21.
//

import Foundation

public enum DownloadConfiguration {
    
    /// Used for upload/download tasks. The transfer continues if if the app is terminated.
    case background
    
    /// Caching session-related data.
    case cached(qos: QualityOfService)
    
    /// Not storing any session-related data to disk.
    case notCached(qos: QualityOfService)
    
    var configuration: URLSessionConfiguration {
        switch self {
        case .background: return .background(withIdentifier: UUID().uuidString)
        case .notCached: return .ephemeral
        case .cached: return .default
        }
    }
    
    var qos: QualityOfService {
        switch self {
        case .background: return .background
        case .cached(let qos): return qos
        case .notCached(let qos): return qos
        }
    }
}
