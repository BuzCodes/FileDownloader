//
//  Event.swift
//  URLSessionExtension
//
//  Created by Alessandro Loi on 04/10/21.
//

import Foundation

public enum Event {
    case file(File)
    case progress(percentage: Double)
}
