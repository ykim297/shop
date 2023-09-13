//
//  ResultModel.swift
//  waterFlower
//
//  Created by Young Kim on 2023/9/10.
//

import Foundation

struct ResultModel:Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: ThumbnailModel
}

struct ThumbnailModel:Codable {
    let path: String
}
