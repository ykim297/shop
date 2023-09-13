//
//  Int+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation


extension Int {
    
    func getDuration() -> String{
        let sign = self.signum()
        let seconds = abs(self)/1000
        //let seconds = abs(self)
        var ms = NSMutableString.init(capacity: 8)
        //let h = seconds / 3600
        let m = seconds / 60 % 60
        let s = seconds % 60
        
        if seconds < 0 {
            ms = "∞"
        } else {
            if sign < 0 { ms = "- " }
            //if h > 0 { ms.appendFormat("%d:", h) }
            if m < 10 { ms.append("0") }
            ms.appendFormat("%d:", m)
            if s < 10 { ms.append("0") }
            ms.appendFormat("%d", s)
        }
        return ms as String
    }
    
    
    
    func timeStringFormat() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.zeroFormattingBehavior = .pad
        let output = formatter.string(from: TimeInterval(self))!
        let index = output.range(of: ":")!.upperBound
        return self < 3600 ? String(output[index...]) : output
    }

    func dateFormat() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day, .weekday, .hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        let output = formatter.string(from: TimeInterval(self))!
        let index = output.range(of: ":")!.upperBound
        return self < 3600 ? String(output[index...]) : output
    }

    
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
        
    func secondsToHoursMinutesSeconds () -> (Int, Int, Int) {

      return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
}
