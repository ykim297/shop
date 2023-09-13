//
//  NSMutableAttributedString+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit


extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
        
    func addFont(font: UIFont, string: String) {
        let range: NSRange = self.mutableString.range(of: string, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
}
//You can do that using attributedText.
//
//try like this
//
//var heading = "Bills or Taxes once paid through the payment gateway shall not be refunded other then in the following circumstances:"
//var content = "\n \n 1. Multiple times debiting of Consumer Card/Bank Account due to ticnical error excluding Payment Gateway charges would be refunded to the consumer with in 1 week after submitting complaint form. \n \n 2. Consumers account being debited with excess amount in single transaction due to tecnical error will be deducted in next month transaction. \n \n 3. Due to technical error, payment being charged on the consumers Card/Bank Account but the Bill is unsuccessful."
//
//let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
//
//attributedText.append(NSAttributedString(string: content, attributes: [NSAttributedStringKey.font: UIFont.SystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.blue]))
//
//refundTextview.attributedText = attributedText
