//
//  Data+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit


extension Data {
    func dictionaryFromJson() -> [String : Any]? {
        do {
            let dic = try JSONSerialization.jsonObject(with: self,
                                                       options: [.mutableContainers]) as? [String : Any]
            return dic
        } catch let error {
            Log.message(to: "\(#function) error: \(error)")
            return nil
        }
    }
    
    func arrayFromJson() -> [[String : Any]]? {
        do {
            let array = try JSONSerialization.jsonObject(with: self,
                                                         options: [.mutableContainers]) as? [[String : Any]]
            return array
        } catch let error {
            Log.message(to: "\(#function) error: \(error)")
            return nil
        }
    }
    
}
