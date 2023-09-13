//
//  UICollectionView+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

extension UICollectionView {
    
    private struct currentIndexPath {
        static var section: Int = 0
        static var row: Int = 0
    }
    
    var section: Int {
        get {
            guard let section = objc_getAssociatedObject(self, &currentIndexPath.section) as? Int else {
                return 0
            }
            return section
        }
        set {
            objc_setAssociatedObject(self, &currentIndexPath.section, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var row: Int {
        get {
            guard let row = objc_getAssociatedObject(self, &currentIndexPath.row) as? Int else {
                return 0
            }
            return row
        }
        set {
            objc_setAssociatedObject(self, &currentIndexPath.row, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
 
    func register<T: UICollectionViewCell>(cellType: T.Type) where T: Reusable {
            register(cellType.self, forCellWithReuseIdentifier: cellType.identifier)
        }

        // ofKind: UICollectionView.elementKindSectionFooter
        func register<T: UICollectionReusableView>(viewType: T.Type, ofKind: String) where T: Reusable {
            register(viewType.self, forSupplementaryViewOfKind: ofKind, withReuseIdentifier: viewType.identifier)
        }

        func dequeueReusableCell<T: UICollectionViewCell>(
            for indexPath: IndexPath,
            cellType: T.Type = T.self
        ) -> T where T: Reusable {
            guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
                fatalError("Failed to dequeue a cell \(cellType.identifier) matching type \(cellType.self).")
            }

            return cell
        }

        func dequeueReusableView<T: UICollectionReusableView>(
            for indexPath: IndexPath, kind: String, viewType: T.Type = T.self
        ) -> T where T: Reusable {
            guard let view = dequeueSupplementary(viewType.identifier, indexPath: indexPath, kind: kind) as? T else {
                fatalError("Failed to dequeue a view \(viewType.identifier) matching type \(viewType.self).")
            }

            return view
        }
}

extension UICollectionView {
    // dequeue the collectionView cell
    func dequeueCell<T: UICollectionViewCell>(_ identifier: String? = nil, indexPath: IndexPath) -> T {
        let identifier = identifier ?? String(describing: T.self)
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
        switch cell {
        case let .some(unwrapped): return unwrapped
        default: fatalError("Unable to dequeue" + T.description())
        }
    }

    // claim the collectionView cell
    func register<T: UICollectionViewCell>(_ type: T.Type, identifier: String? = nil) {
        let identifier = identifier ?? String(describing: T.self)
        register(type, forCellWithReuseIdentifier: identifier)
    }
}

extension UICollectionView {
    func dequeueSupplementary<T: UICollectionReusableView>(
        _ identifier: String? = nil,
        indexPath: IndexPath,
        kind: String
    ) -> T {
        let identifier = identifier ?? String(describing: T.self)
        let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T
        switch view {
        case let .some(unwrapped): return unwrapped
        default: fatalError("Unable to dequeue" + T.description())
        }
    }

    func register<T: UICollectionReusableView>(_ type: T.Type, identifier: String? = nil, kind: String) {
        let identifier = identifier ?? String(describing: T.self)
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}

extension UICollectionView {
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}
