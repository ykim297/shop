//
//  CollectionContainerView.swift
//  marvel
//
//  Created by Millan on 2023/09/13.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class CollectionContainerView: BaseView {
    
    let collectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let empty = UILabel()
    var listItem: BehaviorRelay<[ResultModel]> = BehaviorRelay(value: [])
    var indexPath = IndexPath(row: 0, section: 0)
    var rxPages = PublishSubject<Int>()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init() {
        super.init(frame: .zero)

        setComponent()
        setAutoLayOut()
        setRxFunction()
    }

    override func setComponent() {
        super.setComponent()
        self.addSubview(collectionView)
        collectionView.setLayerBorder()
        self.addSubview(empty)
        empty.setLayerBorder()

        setCollectionView()
        setEmptyLabel()
    }

    override func setAutoLayOut() {
        super.setAutoLayOut()

        collectionView.snp.makeConstraints { [weak self] view in
            guard let self = self else { return }
            view.top.left.right.bottom.equalTo(self)
        }

        empty.snp.makeConstraints { [weak self] view in
            guard let self = self else { return }
            view.centerX.centerY.equalTo(self)
        }
    }

    override func setRxFunction() {
        super.setRxFunction()
        collectionView.rx.itemSelected
            .subscribe(onNext: { index in
                print("\(index.section) \(index.row)")
            })
            .disposed(by: self.disposedBag)
    }
}

extension CollectionContainerView {
    
    private func setCollectionView() {
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(cellType: CollectionViewCell.self)
        self.setLayerBorder(color: .blue, width: 2.0)
        
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        
        
        setDataSource()
    }

    private func setEmptyLabel() {
        empty.text = "No the content.\n Please select the marvel character."
        empty.textAlignment = .center
        empty.textColor = .colorRGB(163, 163, 163)
        empty.numberOfLines = 2
        empty.font = .systemFont(ofSize: 14.0)
        empty.isHidden = true
    }

    //Set attributes of RxtableView on this View
    private func setDataSource() {
        
        listItem.asObservable()
            .bind(to: collectionView.rx
                    .items(cellIdentifier: "CollectionViewCell", cellType: CollectionViewCell.self)) { index, color, cell in
                        cell.setLayerBorder()
                        cell.setData(data: self.listItem.value[index])
                }
                .disposed(by: self.disposedBag)
        
    }
}

extension CollectionContainerView: UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           let list = listItem.value
           return list.count
       }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let collectionViewContentSizeY = self.collectionView.contentSize.height
        let paginationY = self.screenHeight + 20.0
        if contentOffsetY > collectionViewContentSizeY - paginationY {
            let page = self.listItem.value.count/10
            self.rxPages.onNext(page)
        }
    }
}

extension CollectionContainerView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let witdh = UIScreen.width/2
        let height = UIScreen.height/3
        
        return CGSize(width: witdh, height: height)
    }
    
}








