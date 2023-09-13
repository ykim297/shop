//
//  String+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit
import CryptoKit

extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    //스페이스 유무
    func containsWhitespace() -> Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }

    //Json to Dictionary
    func dictionaryFromJson() -> [String : String]? {
        var ret: [String : String]? = nil
        guard let data = self.data(using: .utf8) else {
            Log.message(to: "Fail to encoded(\(self))")
            return ret
        }
        
        do {
            ret = try JSONSerialization.jsonObject(with: data, options: .mutableContainers ) as? [String : String]
        } catch let error  {
            Log.message(to: "\(#function) error: \(error)")
        }
        
        return ret
    }
    
    //Json to Array
    func arrayFromJson() -> [ [String : String]?]? {
        var ret: [ [String : String]?]? = nil
        guard let data = self.data(using: .utf8) else {
            Log.message(to: "Fail to encoded(\(self))")
            return ret
        }
        
        do {
            ret = try JSONSerialization.jsonObject(with: data, options: .mutableContainers ) as? [[String : String]?]
        } catch let error  {
            Log.message(to: "\(#function) error: \(error)")
        }
        
        return ret
    }
    
    func stringLength(font: UIFont? = nil, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        var tempFont: UIFont
        if let f = font {
            tempFont = f
        } else {
            tempFont = UIFont.systemFont(ofSize: fontSize)
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 999.0, height: height))
        label.font = tempFont
        label.text = self

        label.sizeToFit()
        return label.frame.size.width
    }

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    // convert String to Image
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
    
    func newString(split: Character, replace: String) -> String {
        let words = self.split(separator: split)
        let newString = words[0].replacingOccurrences(of: "-", with: replace, options: .literal, range: nil)
        return newString
    }

    func getDate(format: String, timeZone: String? = nil) -> String {
        let formatter = DateFormatter()
        guard let date: Date = formatter.date(from: self) else {
            return "Invalid Date"
        }
        
        if let tz = timeZone {
            formatter.timeZone = TimeZone(identifier: tz)
        }
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // get height
    func height(width: CGFloat,
                font: UIFont = UIFont.systemFont(ofSize: 16.0)) -> CGFloat {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.text = self
            label.font = font
            label.sizeToFit()

            return label.frame.height
        }
    
}

/* Date */
extension String {    
    func date(format: String, timeZone: TimeZone = TimeZone.current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: self)
        return date
    }
}


//암호화
//extension String {
//    func sha512() -> String? {
//        guard let data = self.data(using: .utf8) else { return nil }
//        let sha512 = SHA512.hash(data: data)
//        let hashString = sha512.compactMap { String(format: "%02x", $0) }.joined()
//        return hashString
//    }
//
//    func sha512(_ salt: String) -> String? {
//        let salt = salt + self
//        guard let data = salt.data(using: .utf8) else { return nil }
//        let sha512 = SHA512.hash(data: data)
//        let hashString = sha512.compactMap { String(format: "%02x", $0) }.joined()
//        return hashString
//    }
//
//    //이메일 마스킹
//    var maskEmail: String {
//        let email = self
//        let components = email.components(separatedBy: "@")
//        guard let first = components.first, let last = components.last else {
//            return self
//        }
//
//        var maskEmail = ""
//
//        var arr: [Int] = []
//        let count = first.count
//
//        switch count {
//        case 1:
//            arr.append(0)
//            break
//        case 2,3:
//            let newCount = count - 1
//            for i in 0..<newCount {
//                arr.append(i)
//            }
//            break
//        case 4,5:
//            let newCount = count - 2
//            for i in 0..<newCount {
//                arr.append(i)
//            }
//            break
//        case 6,7:
//            let newCount = count - 3
//            for i in 0..<newCount {
//                arr.append(i)
//            }
//            break
//        case 8:
//            let newCount = count - 4
//            for i in 0..<newCount {
//                arr.append(i)
//            }
//            break
//        default:
//            let newCount = count - 5
//            for i in 0..<newCount {
//                arr.append(i)
//            }
//            break
//        }
//
//        maskEmail = String(first.enumerated().map { index, char in
//            return arr.contains(index) ? char : "*"
//        })
//
//        maskEmail = maskEmail + "@" + last
//
//        return maskEmail
//    }
//
//    var maskPhoneNumber: String {
//        return String(self.enumerated().map { index, char in
//            return [0, 3, self.count - 1, self.count - 2].contains(index) ?
//                char : "*"
//        })
//    }
//}

extension String {
    
    func attributedString(
        font: UIFont,
        color: UIColor? = nil,
        customLineHeight: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        kern: Double? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        underlineStyle: NSUnderlineStyle? = nil,
        strikeThroughStyle: NSUnderlineStyle? = nil
    ) -> NSAttributedString {
        let finalKern: Double = kern ?? 0.0
        let finalLineHeight: CGFloat = customLineHeight ?? font.lineHeight
        let finalColor: UIColor = color ?? .black

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = finalLineHeight - font.lineHeight

        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }

        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }

        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: finalColor,
            .font: font,
            .kern: finalKern,
            .paragraphStyle: paragraphStyle
        ]

        if let underlineStyle = underlineStyle {
            attributes.updateValue(underlineStyle.rawValue, forKey: .underlineStyle)
        }

        if let strikeThroughStyle = strikeThroughStyle {
            attributes.updateValue(strikeThroughStyle.rawValue, forKey: .strikethroughStyle)
        }

        return NSAttributedString(string: self, attributes: attributes)
    }

    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        // swiftformat:disable:next redundantSelf
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return boundingBox.height
    }

    func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex ..< endIndex])
    }

    func validateUrl() -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
    func getKorean() -> String {
        switch self {
        case "Mon":
            return "월"
        case "Tue":
            return "화"
        case "Wed":
            return "수"
        case "Thu":
            return "목"
        case "Fri":
            return "금"
        case "Sat":
            return "토"
        case "Sun":
            return "일"
        default:
            return ""
        }
    }
}

// MARK: - FilePath

extension String {
    func extractClassName() -> String {
        guard let fileName = components(separatedBy: "/").last,
            let className = fileName.components(separatedBy: ".").first else {
            return "No FilePath"
        }

        return className
    }
}

extension String {

    // check email Type validly
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    var isValidURL: Bool {
        // swiftlint:disable:next force_try
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == utf16.count
        } else {
            return false
        }
    }

    // add underline on String
    func underLines(list: [String]) -> NSAttributedString {
        let underLines = NSMutableAttributedString(string: self)

        for str in list {
            let range = (self as NSString).range(of: str.localized)
            underLines.addAttribute(
                NSAttributedString.Key.underlineStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: range
            )
        }

        return underLines
    }

    // convert string to dictionary
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }

    // find index of character on String
    //    "apple".indexes(of: "p") // [1, 2]
    //    "element".indexes(of: "e") // [0, 2, 4]
    //    "swift".indexes(of: "j") // []
    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: "\(char)")
    }

    func indexes(of character: String) -> [Int] {
        precondition(character.count == 1, "Must be single character")

        return enumerated().reduce([]) { partial, element in
            if String(element.element) == character {
                return partial + [element.offset]
            }
            return partial
        }
    }
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    // check a special character on String
    func hasSpecial() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(
                in: self,
                options: NSRegularExpression.MatchingOptions.reportCompletion,
                range: NSRange(location: 0, length: count)
            ) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
    
    // check number on String
    func hasNumber() -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        return containsNumber
    }
    
    func hasKorean() -> Bool {
        let numberRegEx  = "[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        return containsNumber
    }
    
    // check alphabet on String
    func hasAlphabet() -> Bool {
        let numberRegEx  = ".*[a-zA-Z]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: self)
        return containsNumber
    }

    // get String width size by font size and height
    func stringSize(font: UIFont? = nil, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        var tempFont: UIFont
        if let f = font {
            tempFont = f
        } else {
            tempFont = UIFont.systemFont(ofSize: fontSize)
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 999.0, height: height))
        label.font = tempFont
        label.text = self

        label.sizeToFit()
        return label.frame.size.width
    }

    // get String height size by font size and height
    func getHeight(width: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 16.0)) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()

        return label.frame.height
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

public extension StringProtocol where Index == String.Index {
    func indexDistance(of element: Element) -> Int? {
        firstIndex(of: element)?.distance(in: self)
    }

    func indexDistance<S: StringProtocol>(of string: S) -> Int? {
        range(of: string)?.lowerBound.distance(in: self)
    }

    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }

    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }

    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start ..< endIndex].range(of: string, options: options) {
            result.append(range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound :
                index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }

    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start ..< endIndex].range(of: string, options: options) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound :
                index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension String
{
    func replace(target: String, with: String) -> String {
       return self.replacingOccurrences(of: target, with: with, options: .literal, range: nil)
    }
}

extension String {
    // convert String to Date
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension String {
    func sizeForWidth(width: CGFloat, font: UIFont) -> CGSize {
        let attr = [NSAttributedString.Key.font: font]
        let height = NSString(string: self).boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attr,
            context: nil
        ).height
        return CGSize(width: width, height: ceil(height))
    }

    func checkUrl(text: String) -> String? {
        // swiftlint:disable:next force_try
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            let url = text[range]
            Log.message(to: "\(url)")
            let link: String = String(url)
            return link
        }

        return nil
    }
}

extension String {
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func truncate(to maximumCharacters: Int) -> String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count > maximumCharacters {
            return "\(trimmed[..<index(startIndex, offsetBy: maximumCharacters)])" + "..."
        }
        return trimmed
    }
        
        
    func pathAvailable() -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(self)") {
//            print("Path AVAILABLE")
            return true
        } else {
//            print("FILE PATH NOT AVAILABLE")
           return false
        }
    }
        
    func fileExist(type: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
         let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(self).\(type)") {
             let filePath = pathComponent.path
             let fileManager = FileManager.default
             if fileManager.fileExists(atPath: filePath) {
//                 print("FILE AVAILABLE")
                return true
             } else {
//                 print("FILE NOT AVAILABLE")
                return false
             }
         } else {
//             print("FILE PATH NOT AVAILABLE")
            return false
         }
    }
    
}
