//
//  UILabel+Extension.swift
//  TicketGateway
//
//  Created by Dr.Mac on 02/06/23.

import Foundation
import UIKit


//MARK: - Attributed Text

    func getAttributedTextAction(attributedText: String, firstString: String, lastString: String, attributedFont: UIFont, attributedColor: UIColor = .red, isToUnderLineAttributeText: Bool = true) -> NSMutableAttributedString {
        // example
        //  let fullString = StringConstants.temsAndConditionlbl + termsCondition
        
        let attributedText = attributedText
        let fullString = firstString + attributedText + lastString
        let strNSString: NSString = fullString as NSString
        let rangeNumber = (strNSString).range(of: attributedText)
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: attributedColor, range: rangeNumber)
        if isToUnderLineAttributeText {
            attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeNumber)
        }
        attribute.addAttribute(NSAttributedString.Key.font, value: attributedFont, range: rangeNumber)
        return attribute
    }

    //MARK: - Gradient Text
    func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        //We are creating UIImage to get gradient color.
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        // gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.colors = [UIColor.setColor(colorType: .startTextGradientColor).cgColor, UIColor.setColor(colorType: .endTextGradientColor).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
