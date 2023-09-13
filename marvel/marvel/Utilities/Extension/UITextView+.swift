//
//  UITextView+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit
extension UITextView {
    // get line numbers of textView by fontSize
    func numberOfLines() -> Int {
        if let fontUnwrapped = font {
            return Int(contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }

    // count line numbers of textView by range
    func countLines() -> Int {
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var index = 0, numberOfLines = 0
        var lineRange = NSRange(location: NSNotFound, length: 0)

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }

        return numberOfLines
    }
    
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

extension UITextInput {
    var selectedRange: NSRange? {
        guard let range = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}
