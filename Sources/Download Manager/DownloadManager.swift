//
//  File.swift
//  
//
//  Created by Alessandro Loi on 05/10/21.
//

import Foundation

class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    private override  init()  { }
    
    private var activeDownloads: [Download] = []
    
    private var closures: [String: (completion: DownloadCompletion, progress: DownloadProgress?)] = [:]
    
    private let delegateQueue = OperationQueue()
    
    private lazy var downloadSession = URLSession(configuration: configuration,
                                                  delegate: self,
                                                  delegateQueue: delegateQueue)
    
    public var configuration: URLSessionConfiguration!
    
    func download(file: File,
                  onProgress: DownloadProgress?,
                  onCompletion: @escaping DownloadCompletion) {
        
        closures[file.id] = (onCompletion, onProgress)
        
        configuration = file.downloadConfiguration.configuration
        delegateQueue.qualityOfService = file.downloadConfiguration.qos
        
        guard
            let url = file.downloadURL
        else {
            onCompletion(.failure(.invalidURL))
            return
        }
        
        let downloadModel = Download(downloadable: file, downloadTask: downloadSession.downloadTask(with: url))
        activeDownloads.append(downloadModel)
    }
    
    func pause(_ file: File) {
        guard
            let activeDownload = activeDownloads.first(where: { $0.url == file.downloadURL }),
            activeDownload.isDownloading
        else { return }
        
        activeDownload.isDownloading = false
        activeDownload.downloadTask.cancel(byProducingResumeData: { data in
            activeDownload.resumeData = data
        })
        
        print("Paused file from \(String(describing: file.downloadURL))")
    }
    
    func cancel(_ file: File) {
        guard
            let activeDownload = activeDownloads.first(where: { $0.url == file.downloadURL })
        else { return }
        
        activeDownload.downloadTask.cancel()
        
        activeDownloads.removeAll(where: { $0.url == activeDownload.url })
        
        print("Canceled download from \(String(describing: file.downloadURL))")
    }
    
    func resume(_ file: File) {
        guard
            let download = activeDownloads.first(where: { $0.url == file.downloadURL })
        else { return }
        
        if let resumeData = download.resumeData {
            print("Resuming")
            
            download.downloadTask = downloadSession.downloadTask(withResumeData: resumeData)
        } else if let url = file.downloadURL {
            print("Starting Again")
            
            download.downloadTask = downloadSession.downloadTask(with: url)
        } else  {
            closures[download.file.id]?.completion(.failure(.invalidURL))
        }
        
        download.isDownloading = true
        download.downloadTask.resume()
        
        print("Resumed download from \(String(describing: file.downloadURL))")
    }
    
    private func forwardResult(_ file: File, error: FileHandlerError?) {
        if let error = error {
            closures[file.id]?.completion(.failure(error))
        } else {
            closures[file.id]?.completion(.success(file))
        }
    }
}

// MARK: - URLSessionDownloadDelegate

extension DownloadManager: URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard
            let sourceURL = downloadTask.originalRequest?.url,
            let download = activeDownloads.first(where: { $0.url == sourceURL })
        else { return }
        
        do {
            let fileDirectoryURL = FileManager.default.urls(for: download.file.directory, in: .userDomainMask)[0]
            
            let lastPathComponent: String
            if let fileName = download.file.name {
                lastPathComponent = sourceURL.pathExtension.isEmpty ? fileName : fileName + ("." + sourceURL.pathExtension)
            } else {
                lastPathComponent = sourceURL.lastPathComponent
            }
            
            let savedURL = fileDirectoryURL.appendingPathComponent(lastPathComponent)
            
            try? FileManager.default.removeItem(at: savedURL)
            try FileManager.default.moveItem(at: location, to: savedURL)
            
            download.file.localURL = savedURL
            
            forwardResult(download.file, error: nil)
            
        } catch {
            forwardResult(download.file, error: .savingItem)
        }
        
        activeDownloads.removeAll(where: { $0.url == download.url })
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard
            let sourceURL = downloadTask.originalRequest?.url,
            let download = activeDownloads.first(where: { $0.url == sourceURL })
        else { return }
        
        closures[download.file.id]?.progress?(downloadTask.progress.fractionCompleted)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
        guard
            let error = error,
            let sourceURL = task.originalRequest?.url,
            let download = activeDownloads.first(where: { $0.url == sourceURL }),
            download.isDownloading
        else { return }
        
        let userInfo = (error as NSError).userInfo
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            download.resumeData = resumeData
        } else {
            forwardResult(download.file, error: .genericError(error))
        }
    }
}
