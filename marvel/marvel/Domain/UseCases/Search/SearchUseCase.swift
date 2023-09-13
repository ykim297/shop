//
//  SearchUseCase.swift
//  marvel
//
//  Created by Yong seok Kim on 2023/09/10.
//

import Foundation


protocol SearchUseCase: BaseUseCase {
    func requestSearch(request: Search.Request,
                       completion: @escaping( Bool,[ResultModel]?, String?) -> Void)

}
