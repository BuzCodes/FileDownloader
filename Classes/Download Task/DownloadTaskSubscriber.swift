//
//  DownloadTaskSubscriber.swift
//  URLSessionExtension
//
//  Created by Alessandro Loi on 04/10/21.
//

import Combine

@available(iOS 13.0, *)
class DownloadTaskSubscriber: Subscriber {
    public typealias Input = Event
    public typealias Failure = FileHandlerError

    private(set) var subscription: Subscription?
    
    public init () {}

    public func receive(subscription: Subscription) {
        self.subscription = subscription
        self.subscription?.request(.unlimited)
    }

    public func receive(_ input: Input) -> Subscribers.Demand {
        return .unlimited
    }

    public func receive(completion: Subscribers.Completion<Failure>) {
        subscription?.cancel()
        subscription = nil
    }
}
