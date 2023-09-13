//
//  CollectionViewCell.swift
//  marvel
//
//  Created by Millan on 2023/09/13.
//

import UIKit
import Kingfisher
import Nuke

class CollectionViewCell: UICollectionViewCell, Reusable {
    public static var identifier: String = "CollectionViewCell"
    let selectedView: UIView = UIView()
    
    let image: UIImageView = UIImageView()
    let title: UILabel = UILabel()
    let descript: UILabel = UILabel()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override var isSelected: Bool {
//        didSet {
//            self.selectedView.isHidden = isSelected ? false : true
//        }
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(image)
        image.setLayerBorder(color: .red, width: 2)
        
        title.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        title.textAlignment = .left
        title.textColor = .black
        self.addSubview(title)
        title.setLayerBorder()

        descript.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        descript.textAlignment = .left
        descript.textColor = .black
        descript.numberOfLines = 3
        
        self.addSubview(descript)
        descript.setLayerBorder()
        
        selectedView.backgroundColor = UIColor.colorRGBA(100, 100, 100, 0.2)
        selectedView.isHidden = true
        self.addSubview(selectedView)

        setAutolayOut()
    }
            
    
    func setAutolayOut() {
        let height = UIScreen.height/5
        selectedView.snp.makeConstraints { view -> Void in
            view.top.left.right.bottom.equalTo(self)
        }
        
        image.snp.makeConstraints { view -> Void in
            view.top.left.right.equalTo(self)
            view.height.equalTo(height)
        }
        
        title.snp.makeConstraints { view -> Void in
            view.top.equalTo(self.image.snp.bottom).offset(10.0)
            view.left.right.equalTo(self)
            view.height.equalTo(24.0)
        }

        descript.snp.makeConstraints { view -> Void in
            view.top.equalTo(self.title.snp.bottom).offset(10.0)
            view.left.right.bottom.equalTo(self)
        }

    }
    
    func setData(data: ResultModel) {

        let url = URL(string: "\(data.thumbnail.path)"+".jpg")
        self.image.contentMode = .scaleToFill
        let options = ImageLoadingOptions(placeholder: nil,
                                          transition: .fadeIn(duration: 0.5),
                                          failureImage: nil,
                                          failureImageTransition: .none)
        Nuke.loadImage(with: url, options: options, into: self.image)

        title.text = data.name
        descript.text = data.description
        
        let manager = AppManager.shared
        self.selectedView.isHidden = true
        guard let list = manager.getCharacters() else { return }
        for i in list {
            if i.id == data.id {
                self.selectedView.isHidden = false
            }
        }
        
    }
     
    
}
