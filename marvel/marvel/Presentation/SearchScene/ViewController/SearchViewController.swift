//
//  SearchViewController.swift
//  marvel
//
//  Created by Yong seok Kim
//

import UIKit
import RxSwift

class SearchViewController: BaseViewController {

    var viewModel: SearchViewModel?
    let containerView: CollectionContainerView = CollectionContainerView()
        
    deinit {
        Log.message(to: "Log message")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.containerView.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.closeIndicator()
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setComponent()
        setAutolayOut()
        setRxFunction()
        bindViewModel()
    }
    
    override func setComponent() {
        super.setComponent()
        self.view.backgroundColor = .white
        
        self.view.addSubview(containerView)
        containerView.setLayerBorder()
        
        self.view.bringSubviewToFront(self.indicatorView)
    }
    
    override func setAutolayOut() {
        super.setAutolayOut()
        
        containerView.snp.makeConstraints { [weak self] view in
            guard let self = self else { return }
            view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            view.left.right.bottom.equalTo(self.view)
        }
    }
    
    func setRxFunction() {
    }
    
}

extension SearchViewController {
        
    private func bindViewModel() {
        self.showIndicator()

        guard let model = self.viewModel else { return }
        model.items.bind(to: self.containerView.listItem).disposed(by: self.disposedBag)

        let selectedEvent = containerView.collectionView.rx.itemSelected.asObservable()
        let pageEvent = containerView.rxPages.asObservable()
        let input = SearchViewModel.Input(itemSelectedEvent: selectedEvent,
                                          pageEvent: pageEvent)
        
        let output: SearchViewModel.Output = model.transform(input: input, disposeBag: self.disposedBag)
        
        output.selectedCell.asObservable().subscribe() { [weak self]  value in
            guard let self = self else { return }
            if let indexPath = value.element {
                self.containerView.indexPath = indexPath
                let collection = self.containerView.collectionView
                collection.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                let manager = AppManager.shared
                guard let list:[ResultModel] = manager.getCharacters() else {
                    manager.setCharacters(model: model.results![indexPath.row])
                    self.containerView.collectionView.reloadData()
                    return
                }

                var check = false
                for i in 0..<list.count {
                    if list[i].id == model.results![indexPath.row].id {
                        check = true
                        break
                    }
                }

                if !check {
                    manager.setCharacters(model: model.results![indexPath.row])
                } else {
                    manager.removeCharacter(model: model.results![indexPath.row])
                }
                self.containerView.collectionView.reloadData()
                
            }
        }
        .disposed(by: self.disposedBag)

        output.items.asObservable().subscribe() { [weak self] value in
            guard let self = self else { return }
            self.closeIndicator()
            if let list = value.element {
                self.containerView.listItem.accept(list)                
            }
        }
        .disposed(by: self.disposedBag)

    }
}


