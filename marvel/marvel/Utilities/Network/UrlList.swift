//
//  UrlList.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation

// Host URL Setting
struct DevelopURL {
    let url: String
    let imageUrl: String
    let contentUrl: String
    
    init() {
        self.url = "https://gateway.marvel.com"
        self.imageUrl = ""
        self.contentUrl = ""
    }
}

struct RelaseURL {
    let url: String
    let imageUrl: String
    let contentUrl: String

    init() {
        self.url = ""
        self.imageUrl = ""
        self.contentUrl = ""
    }
}

//Service URL List
enum ServiceUrl {
    
    struct Get {        
        static let list: String = "/v1/public/characters"
//        static let list: String = "/v1/public/characters?limit=10&ts=%@&apikey=%@&hash=%@"  //{limit},{ts},{apikey},{hash}
               
    }
    
    struct Post {
        //template
        static let api: String = "/api/%@"  //{String}
    }
    
}

class UrlList {
    class func url(url:String) -> String {
        let domain: String = AppManager.shared.isRelease ? RelaseURL().url : DevelopURL().url
        return "\(domain)\(url)"
    }
    
    class func imageUrl(path: String) -> String {
        let domain: String = AppManager.shared.isRelease ? RelaseURL().imageUrl : DevelopURL().imageUrl
        return "\(domain)\(path)"
    }
            
    class func contentUrl(url: String) -> String {
        let domain: String = AppManager.shared.isRelease ? RelaseURL().contentUrl : DevelopURL().contentUrl
        return "\(domain)\(url)"
    }
    
}



