//
//  File.swift
//  
//
//  Created by Alessandro Loi on 05/10/21.
//

import Foundation

class Download {
    var isDownloading = false
    var resumeData: Data?
    var progress: Float = 0
    
    var file: File
    var downloadTask: URLSessionDownloadTask
    
    var url: URL? {
        file.downloadURL
    }
    
    init(downloadable: File, downloadTask: URLSessionDownloadTask) {
        self.file = downloadable
        self.downloadTask = downloadTask
        self.downloadTask.resume()
        self.isDownloading = true
    }
}
