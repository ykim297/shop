//
//  ModelParser.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation


class ModelParser {
    static func parsing<T: Codable>(json: Data, type: T.Type, strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, completion: @escaping (_ data: T?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = strategy
            let data = try decoder.decode(type.self, from: json)
            return completion(data, nil)
        } catch let DecodingError.dataCorrupted(context) {
            Log.message(to: "\(#function) error: \(context)")
        } catch let DecodingError.keyNotFound(key, context) {
            Log.message(to: "\(#function) error: Key '\(key)' not found: \(context.debugDescription)")
            Log.message(to: "\(#function) error: codingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            Log.message(to: "\(#function) error: value: \(value) codingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            Log.message(to: "\(#function) error: Type '\(type)' mismatch: \(context.debugDescription)")
            Log.message(to: "\(#function) error: codingPath: \(context.codingPath)")
        } catch {
            Log.message(to: "\(#function) error: Error from JSON because: \(error.localizedDescription)")            
            return completion(nil, error)
        }
    }
}
