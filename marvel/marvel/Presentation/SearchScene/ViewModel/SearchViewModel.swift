//
//  SearchViewModel.swift
//  marvel
//
//  Created by Yong seok Kim
//

import Foundation
import RxRelay
import RxSwift


final class SearchViewModel {
    
    private let coordinator: SearchCoordinator?
    private let usecase: SearchUseCase
    var pages: Int = 0
    var results: [ResultModel]?
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var items: PublishSubject<[ResultModel]> = PublishSubject<[ResultModel]>()
    struct Input {
        let itemSelectedEvent: Observable<IndexPath>
        let pageEvent: Observable<Int>
    }
    
    struct Output {
        var items = PublishSubject<[ResultModel]>()
        let error = PublishSubject<String>()
        var selectedResult = PublishSubject<ResultModel>()
        let selectedCell = PublishSubject<IndexPath>()
    }
    
    init(coordinator: SearchCoordinator?, usecase: SearchUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }

}

extension SearchViewModel {
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        requestHighlight(output: output)
        
        input.itemSelectedEvent.subscribe(onNext: { [weak self]  indexPath in
            Log.message(to: "indexPath: \(indexPath)")
            guard let self = self else { return }
            self.indexPath = IndexPath(row: indexPath.row, section: 0)
            output.selectedCell.onNext(self.indexPath)
        })
        .disposed(by: disposeBag)

        input.pageEvent.subscribe(onNext: { [weak self]  page in
            Log.message(to: "page: \(page)")
            guard let self = self else { return }
            self.pages = page
            self.requestHighlight(output: output)
        })
        .disposed(by: disposeBag)

                
        return output
    }
    
    private func keys() -> (String,String ,String) {
        let timeStamp = "\(Date.currentTimeStamp/1000)"
        let publickey = "f69cf6559688e3bbec15256960a87351"
        let privatekey = "01e9d8880bf8f529ddac95677c4cdef0725cdffa"
        let str = timeStamp + publickey + privatekey
        let md5 = MD5(string: str)
        let md5Hex =  md5.map { String(format: "%02hhx", $0) }.joined()
//        return (timeStamp, publickey, md5Hex)
        return ("1694552607", publickey, "fb91d3fdd250c80817096b298c56ea83")
    }

    
    func requestHighlight(output: Output) {
        let keys = keys()
        let request = Search.Request(limit: 10, offset: self.pages, ts: keys.0, apikey: keys.1, hash: keys.2)
        usecase.requestSearch(request: request) { [weak self] success, response, error in
            guard let self = self else { return }
            if success, let models = response {
                if self.results == nil {
                    self.results = models
                } else {
                    self.results!.append(contentsOf: models)
                }
                
                output.items.onNext(self.results!)
                
            } else {
                output.error.onNext("error")
            }
        }
        
        
    }
}
