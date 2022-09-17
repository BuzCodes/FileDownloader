//
//  DownloadTaskPublisher.swift
//  URLSessionExtension
//
//  Created by Alessandro Loi on 02/10/21.
//

import Combine

@available(iOS 13.0, *)
public struct DownloadTaskPublisher: Publisher {
    
    public typealias Output = Event
    public typealias Failure = FileHandlerError
    
    public let file: File
    
    public init(file: File) {
        self.file = file
    }
    
    public func receive<S>(subscriber: S)
    where S : Subscriber,
          Self.Failure == S.Failure,
          Self.Output == S.Input {
        let subscription = DownloadTaskSubscription(subscriber: subscriber, file: file)
        subscriber.receive(subscription: subscription)
    }
}
