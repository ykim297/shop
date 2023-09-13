//
//  UILabel+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit


extension UILabel {
    // 앞뒤에 이미지를 추가한다.
    // - Parameters:
    // - text: 추가 텍스트
    // - image: 추가이미지
    // - imageBehindText: text 앞뒤 이미지 여부
    // - keepPreviousText: 기존 text를 유지 여부
    func addTextWithImage(
        text: String,
        image: UIImage,
        imageBehindText: Bool,
        keepPreviousText: Bool
    ) {
        let lAttachment = NSTextAttachment()
        lAttachment.image = image

        // 1pt = 1.32px
        let lFontSize = round(font.pointSize * 1)
        let lRatio = image.size.width / image.size.height

        lAttachment.bounds = CGRect(
            x: 0,
            y: ((font.capHeight - lFontSize) / 2).rounded(),
            width: lRatio * lFontSize,
            height: lFontSize
        )

        let lAttachmentString = NSAttributedString(attachment: lAttachment)
        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString

            if keepPreviousText, let lCurrentAttributedString = attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }
            lStrLabelText.append(lAttachmentString)
            attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString

            if keepPreviousText, let lCurrentAttributedString = attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: "  " + text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: "  " + text))
            }

            attributedText = lStrLabelText
        }
    }

    /// image 삭제
    func removeImage() {
        let text = self.text
        attributedText = nil
        self.text = text
    }
    
    // Pass value for any one of both parameters and see result
       func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

           guard let labelText = self.text else { return }

           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = lineSpacing
           paragraphStyle.lineHeightMultiple = lineHeightMultiple

           let attributedString:NSMutableAttributedString
           if let labelattributedText = self.attributedText {
               attributedString = NSMutableAttributedString(attributedString: labelattributedText)
           } else {
               attributedString = NSMutableAttributedString(string: labelText)
           }

           // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

           self.attributedText = attributedString
       }
}


extension UILabel {
  func setLetterSpacingBy(value: Double) {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
    
    
    
    func setLineHeight(lineHeight: CGFloat, value: Double) {
           let text = self.text
           if let text = text {
               let attributeString = NSMutableAttributedString(string: text)
               let style = NSMutableParagraphStyle()
               
               style.lineSpacing = lineHeight
               style.lineHeightMultiple = 0.9
               attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
               attributeString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributeString.length - 1))
               self.attributedText = attributeString
           }
       }
    
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat){
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            style.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4                
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    
}

