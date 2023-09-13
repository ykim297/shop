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
    var searchBar: UISearchBar = UISearchBar()
    var isSearch : Bool = false


        
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
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
        self.view.addSubview(containerView)
        containerView.setLayerBorder()
        
        self.view.bringSubviewToFront(self.indicatorView)
    }
    
    override func setAutolayOut() {
        super.setAutolayOut()
        
        searchBar.snp.makeConstraints { [weak self] view in
            guard let self = self else { return }
            view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            view.left.right.equalTo(self.view)
            view.height.equalTo(40.0)
        }
        
        containerView.snp.makeConstraints { [weak self] view in
            guard let self = self else { return }
            view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40.0)
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


extension SearchViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           isSearch = true
    }
       
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
    }
       
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
    }
       
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let count = searchText.count
        switch count {
        case 0:
            isSearch = false
            guard let model = self.viewModel else { return }
            self.viewModel?.reset = true
            self.requestHighlight()
            break
            
        case 1:
            isSearch = false
            self.viewModel?.reset = false
            break
        default:
            isSearch = true
            guard let model = self.viewModel else { return }
            self.viewModel?.reset = true
            self.requestHighlight(name: searchText)
            break
            
        }
                
    }
    
    private func keys() -> (String,String ,String) {
        let pub = AppManager.shared.publicApi
        let pri = AppManager.shared.privteApi
        let ts = AppManager.shared.timeStamp
        return (ts, pub, pri)
    }
    
    func requestHighlight(name:String? = nil) {
        let keys = keys()
        guard let model = self.viewModel else { return }
        var str: String? = nil
        if self.viewModel!.reset {
            self.viewModel!.results = nil
            self.viewModel!.pages = 0
            if name == "" {
                str = nil
            }else {
                str = name
            }
        }
        
        self.viewModel?.reset = false

        let request = Search.Request(name: str, limit: 10, offset: self.viewModel!.pages, ts: keys.0, apikey: keys.1, hash: keys.2)
        self.viewModel!.usecase.requestSearch(request: request) { [weak self] success, response, error in
            guard let self = self else { return }
            if success, let models = response {
                if self.viewModel!.results == nil {
                    self.viewModel!.results = models
                } else {
                    self.viewModel!.results!.append(contentsOf: models)
                }
                
                self.viewModel!.items.onNext(self.viewModel!.results!)
                
            } else {
                
            }
        }
        
        
    }

}
