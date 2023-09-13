//
//  FavoriteViewModel.swift
//  marvel
//
//  Created by Yong seok Kim on 2023/09/13.
//

import Foundation
import RxRelay
import RxSwift


final class FavoriteViewModel {
    
    private let coordinator: FavoriteCoordinator?
    var pages: Int = 0
    var results: [ResultModel]?
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var items: PublishSubject<[ResultModel]> = PublishSubject<[ResultModel]>()
    struct Input {
        let itemSelectedEvent: Observable<IndexPath>
    }
    
    struct Output {
        var items = PublishSubject<[ResultModel]>()
        var selectedResult = PublishSubject<ResultModel>()
        let selectedCell = PublishSubject<IndexPath>()        
    }
    
    init(coordinator: FavoriteCoordinator?) {
        self.coordinator = coordinator        
    }

}

extension FavoriteViewModel {
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        if let list = AppManager.shared.getCharacters() {
            items.onNext(list)
            results = list
        }
        
        input.itemSelectedEvent.subscribe(onNext: { [weak self]  indexPath in
            Log.message(to: "indexPath: \(indexPath)")
            guard let self = self else { return }
            self.indexPath = IndexPath(row: indexPath.row, section: 0)
            output.selectedCell.onNext(self.indexPath)
        })
        .disposed(by: disposeBag)

                
        return output
    }
    
}

