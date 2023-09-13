//
//  FavoriteViewController.swift
//  marvel
//
//  Created by Yong seok Kim on 2023/09/13.
//

import UIKit
import RxSwift

class FavoriteViewController: BaseViewController {

    var viewModel: FavoriteViewModel?
    let containerView: CollectionContainerView = CollectionContainerView()
        
    deinit {
        Log.message(to: "Log message")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        guard let model = self.viewModel else { return }
        var isHidden = true
        if let list = AppManager.shared.getCharacters() {
            isHidden = false
            model.items.onNext(list)
            model.results = list
        }
        
        self.containerView.collectionView.isHidden = isHidden
        self.containerView.empty.isHidden = !isHidden

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

extension FavoriteViewController {
        
    private func bindViewModel() {

        guard let model = self.viewModel else { return }
        model.items.bind(to: self.containerView.listItem).disposed(by: self.disposedBag)

        var isHidden = true
        if let _ = AppManager.shared.getCharacters() {
            isHidden = false
        }
        
        self.containerView.collectionView.isHidden = isHidden
        self.containerView.empty.isHidden = !isHidden

        let selectedEvent = containerView.collectionView.rx.itemSelected.asObservable()
        
        let input = FavoriteViewModel.Input(itemSelectedEvent: selectedEvent)
        let output: FavoriteViewModel.Output = model.transform(input: input, disposeBag: self.disposedBag)

        output.selectedCell.asObservable().subscribe() { [weak self]  value in
            guard let self = self else { return }
            if let indexPath = value.element {                
                let manager = AppManager.shared
                manager.removeCharacter(model: model.results![indexPath.row])
                if let list = manager.getCharacters() {
                    self.containerView.listItem.accept(list)
                    self.containerView.collectionView.isHidden = false
                    self.containerView.empty.isHidden = true
                } else {
                    self.containerView.collectionView.isHidden = true
                    self.containerView.empty.isHidden = false
                }
                
            }
        }
        .disposed(by: self.disposedBag)

    }
}



