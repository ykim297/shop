//
//  SearchModel.swift
//  marvel
//
//  Created by Millan on 2023/09/13.
//

import Foundation

enum Search{
    
    struct Request: Codable {
        let name: String?
        let limit: Int
        let offset: Int
        let ts: String
        let apikey: String
        let hash: String
    }    

    struct Response: Codable {
        let code: Int
        let status: String
        let copyright: String
        let attributionText: String
        let attributionHTML: String
        let etag: String
        let data: DataModel
    }
    
}
