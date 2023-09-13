//
//  TabPage.swift
//  marvel
//
//  Created by Millan on 2023/09/13.
//

import Foundation

enum TabBarPage {
    case search
    case favorite

    init?(index: Int) {
        switch index {
        case 0:
            self = .search
        case 1:
            self = .favorite
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .search:
            return "Search"
        case .favorite:
            return "Favorite"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .search:
            return 0
        case .favorite:
            return 1
        }
    }

}
