//
//  DownloadTaskSubscription.swift
//  URLSessionExtension
//
//  Created by Alessandro Loi on 04/10/21.
//

import Combine

@available(iOS 13.0, *)
final class DownloadTaskSubscription<SubscriberType: Subscriber>: Subscription
where SubscriberType.Input == Event,
      SubscriberType.Failure == FileHandlerError {
    
    func cancel() {
        DownloadManager.shared.cancel(file)
    }
    
    private let subscriber: SubscriberType
    private let file: File
    
    init(subscriber: SubscriberType, file: File) {
        self.subscriber = subscriber
        self.file = file
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard
            demand > 0
        else { return }
        
        DownloadManager.shared.download(file: file, onProgress: { [weak self] progress in
            _ = self?.subscriber.receive(.progress(percentage: progress))
        }, onCompletion: { [weak self] result in
            switch result {
            case .success(let file):
                _ = self?.subscriber.receive(.file(file))
                self?.subscriber.receive(completion: .finished)
            case .failure(let error):
                self?.subscriber.receive(completion: .failure(error))
            }
        })
    }
}
