//
//  ErrorModel.swift
//  waterFlower
//
//  Created by Young Kim on 2023/09/08.
//

import Foundation

enum NetworkMessage {
    enum Error: String {
        case unknown = "An unknown error has occurred\nwhile loading this content.\nPlease try again."
        case network = "A network connection error has\noccurred. Please check your\nnetwork and try again"
        case retry = "An unknown error has occurred.\nPlease try again"
    }
}

struct ErrorModel: Codable {
    let result: String
    let message: String
    let data: Bool?
}
