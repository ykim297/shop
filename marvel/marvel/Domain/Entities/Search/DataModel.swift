//
//  DataModel.swift
//  marvel
//
//  Created by Yong seok Kim on 2023/09/13.
//

import Foundation

struct DataModel:Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [ResultModel]
}

