//
//  Downloader.swift
//  Downloader
//
//  Created by Alessandro Loi on 15/09/22.
//

import Foundation

public typealias DownloadCompletion = (Result<File, FileHandlerError>) -> Void
public typealias DownloadProgress = (Double) -> Void

public class Downloader {
    
    public static func download(file: File,
                                onProgress: DownloadProgress?,
                                onCompletion: @escaping DownloadCompletion) {
        DownloadManager.shared.download(file: file,
                                        onProgress: onProgress,
                                        onCompletion: onCompletion)
    }
    
    @available(iOS 13.0, *)
    public static func download(file: File) -> DownloadTaskPublisher {
        DownloadTaskPublisher(file: file)
    }
    
    public static func pause(file: File) {
        DownloadManager.shared.pause(file)
    }
    
    public static func resume(file: File) {
        DownloadManager.shared.resume(file)
    }
    
    public static func get(file: File) -> Result<File, FileHandlerError> {
        FileRepository().get(file)
    }
}

