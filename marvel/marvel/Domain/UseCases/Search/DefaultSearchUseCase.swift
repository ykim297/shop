//
//  DefaultSearchUseCase.swift
//  marvel
//
//  Created by Millan on 2023/09/13.
//

import Foundation

final class DefaultSearchUseCase: SearchUseCase {
    
    private let repository: SearchRepository
    
    init(repository: SearchRepository) {
        self.repository = repository
    }
    
    func requestSearch(request: Search.Request,
                          completion: @escaping( Bool, [ResultModel]?, String?) -> Void) {
        
        repository.requestSearch(model: request) { success, response, error in
            if success {
                if let list = response?.data.results {
                    completion(success, list, nil)
                }
            } else {
                if let e = error?.message {
                    completion(false, nil, e)
                } else {
                    completion(false, nil,  NetworkMessage.Error.unknown.rawValue)
                }
            }
        }
    }
    
}

