//
//  Log.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation


class Log: NSObject {
    static func message(filePath: String = #file, line: Int = #line, funcName: String = #function, to:Any...) {
        #if DEBUG
        let now = NSDate()
        let app = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
        print("\(now.description) \(app)] ##### - [\(fileName) \(funcName)][Line \(line)] \(to)")
        #endif
    }
}
