//
//  SearchRepository.swift
//  marvel
//
//  Created by Yong seok Kim on 2023/09/10.
//

import Foundation

protocol SearchRepository {
    func requestSearch(model: Search.Request,
                          completion: @escaping (Bool, Search.Response?, ErrorModel?) -> Void)
}


