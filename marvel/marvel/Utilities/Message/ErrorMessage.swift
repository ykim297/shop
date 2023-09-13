//
//  ErrorMessage.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation

enum NetworkError {
    enum Message: String {
        case unknown = "An unknown error has occurred\nwhile loading this content.\nPlease try again."
        case network = "A network connection error has\noccurred. Please check your\nnetwork and try again"
        case retry = "An unknown error has occurred.\nPlease try again"        
    }
}
