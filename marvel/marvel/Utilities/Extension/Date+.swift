//
//  Date+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation

/* String */
extension Date {
        

    func string(width format: String,
                timeZone: TimeZone = TimeZone.current,
                locale: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        formatter.locale = locale != nil ? locale : Locale(identifier: Locale.preferredLanguages.first ?? "en")
        
        let string = formatter.string(from: self)
        return string
    }
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func toInt() -> Int {
        let timeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    func differentDays(_ date:Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
    
    var relativeTime: String {
        let now = Date()
        if now.years(from: self)   > 0 {
            return now.years(from: self).description + "year".localized  + { return now.years(from: self)   > 1 ? "times".localized : "" }() + "ago".localized
        }
        if now.months(from: self)  > 0 {
            return now.months(from: self).description + "month".localized + { return now.months(from: self)  > 1 ? "times".localized : "" }() + "ago".localized
        }
        if now.weeks(from:self)   > 0 {
            return now.weeks(from: self).description + "week".localized  + { return now.weeks(from: self)   > 1 ? "times".localized : "" }() + "ago".localized
        }
        if now.days(from: self)    > 0 {
            if now.days(from:self) == 1 { return "yesterday".localized }
            return now.days(from: self).description + "days ago".localized
        }
        if now.hours(from: self)   > 0 {
            return "\(now.hours(from: self))" + "hour".localized + { return now.hours(from: self) > 1 ? "times".localized : "" }() + "ago".localized
        }
        if now.minutes(from: self) > 0 {
            return "\(now.minutes(from: self))" + "minute".localized + { return now.minutes(from: self) > 1 ? "times".localized : "" }() + "ago".localized
        }
        if now.seconds(from: self) > 0 {
            if now.seconds(from: self) < 15 { return "just now".localized  }
            return "\(now.seconds(from: self))" + "second".localized + { return now.seconds(from: self) > 1 ? "times".localized : "" }() + "ago".localized
        }
        return ""
    }

    enum WeekDay: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
    
    func getWeekDay() -> WeekDay {
        let calendar = Calendar.current
        let weekDay = calendar.component(Calendar.Component.weekday, from: self)
        return WeekDay(rawValue: weekDay)!
    }
    
    func toString(format:String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        df.locale = Locale(identifier:"ko_KR")
        let now = df.string(from: self)
        return now
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
}
