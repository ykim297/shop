//
//  UITableView+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

extension UITableView {
    /// Reusable 프로토콜을 구현한 TableViewCell 의 register
    ///
    /// For Example:
    /// ```
    /// tableView.register(cellType: TableViewCell.self)
    /// ```
    ///
    /// - Parameter cellType: Reusable type cell

    func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.identifier)
    }
    
    ///  Reusable 프로토콜을 구현한 TableViewCell 을 register후 reuse
    ///
    ///  For Example:
    ///  ```
    ///  let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TableViewCell.self)
    ///  ```
    ///
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - cellType: Reusable TableCell type
    func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell \(cellType.identifier) matching type \(cellType.self).")
        }
        cell.row = 1
        return cell
    }
}

