//
//  Dictionary+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation

extension Dictionary {
    var queryString: String? {
        return self.reduce("") { "\($0!)\($1.0)=\($1.1)&" }
    }
    
    func contains(key: Key) -> Bool {
      self.index(forKey: key) != nil
    }
    
//    func dictionaryToObject<T:Decodable>(objectType:T.Type) -> [T]? {
//        guard let dictionaries = try? JSONSerialization.data(withJSONObject: self) else {
//            return nil
//        }
//        
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        guard let objects = try? decoder.decode([T].self, from: dictionaries) else { return nil }
//        return objects        
//    }
    
    
    func dictionaryToObject<T:Decodable>(objectType:T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let obj = try decoder.decode(objectType, from: jsonData)
            //print("[\(#function)][\(#line)] >>>>>> \(obj) ")
            return obj
            
        } catch {
            Log.message(to: error.localizedDescription)            
            return nil
        }
    }
}
