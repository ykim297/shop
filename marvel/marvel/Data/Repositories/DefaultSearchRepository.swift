//
//  DefaultSearchRepository.swift
//  marvel
//
//  Created by Millan on 2023/09/13.
//

import Foundation

final class DefaultSearchRepository: SearchRepository {
        
    func requestSearch(model: Search.Request,
                       completion: @escaping (Bool, Search.Response?, ErrorModel?) -> Void) {
        
        let setUrl = ServiceUrl.Get.list
        let url: String = "\(UrlList.url(url: setUrl))"
        NetworkManager.request(method: .get, url: url, param: model.dictionary) { response, success, error in
            if let r = response {
                if success {
                    ModelParser.parsing(json: r, type: Search.Response.self) { data, error in
                        if let _ = error { return }
                        completion(success, data, nil)
                    }
                } else {
                    ModelParser.parsing(json: r, type: ErrorModel.self) { data, error in
                        if let _ = error {return}
                        completion(success, nil, data)
                    }
                }
            } else {
                completion(false, nil, error)
            }
        }
                    
    }
    
}
