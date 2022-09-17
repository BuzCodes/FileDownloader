//
//  FileDownloaderError.swift
//  URLSessionExtension
//
//  Created by Alessandro Loi on 04/10/21.
//

/// ""
public enum FileHandlerError: Error {
    /// Error while handling the FileManager.
    /// Could be encountered while moving the item from a tmp position or while deleting an item previously on a tmp position.
    case savingItem
    
    /// Generic network error with underlying Error.
    case genericError(_ error: Error)
    
    /// Invalid URL
    case invalidURL
    
    
    /// File not found in FileManager
    case fileNotFound
    
    /// Printable error description
    public var errorDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .savingItem: return "Error while saving the item."
        case .fileNotFound: return "File not found with filename"
        case .genericError(let error): return error.localizedDescription
        }
    }
}
