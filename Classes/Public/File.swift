//
//  Downloadable.swift
//  URLSessionExtension
//
//  Created by Alessandro Loi on 04/10/21.
//

import Foundation

public struct File {
    let id = UUID().uuidString
    
    let downloadConfiguration: DownloadConfiguration
    
    public let directory: FileManager.SearchPathDirectory
    public var downloadURL: URL?
    public var localURL: URL?
    
    public let name: String?
    
    // Use this to download a file
    public init(url: URL?,
                named: String? = nil,
                directory: FileManager.SearchPathDirectory = .documentDirectory,
                downloadConfiguration: DownloadConfiguration = .background) {
        self.downloadConfiguration = downloadConfiguration
        self.downloadURL = url
        self.name = named
        self.directory = directory
    }
    
    // Use this to fetch a file from the FileManager
    public init(named name: String? = nil,
                in directory: FileManager.SearchPathDirectory = .documentDirectory) {
        self.downloadConfiguration = .background
        self.name = name
        self.directory = directory
    }
}
