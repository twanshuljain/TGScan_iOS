//
// UIFont+Extension.swift
// TicketGateway
//
// Created by Apple on 14/04/23.
//
import UIKit
// FontFamily Setups
enum CustomFontSize: CGFloat {
  case eight = 8
  case nine = 9
  case ten = 10
  case eleven = 11
  case twelve = 12
  case thirteen = 13
  case fourteen = 14
  case fifteen = 15
  case sixteen = 16
  case seventeen = 17
  case eighteen = 18
  case nineteen = 19
  case twenty = 20
  case twentyOne = 21
  case twentyTwo = 22
  case twentyThree = 23
  case twentyFour = 24
  case twentyFive = 25
  case twentySix = 26
  case twentySeven = 27
  case twentyEight = 28
  case thirtyTwo = 32
  case thirtySix = 36
//  case others(value: CGFloat = 0)
}
enum CustomFont: String {
  case black = "Poppins-Black"
  case bold = "Poppins-Bold"
  case extraBold = "Poppins-ExtraBold"
  case extraLight = "Poppins-ExtraLight"
  case light = "Poppins-Light"
  case medium = "Poppins-Medium"
  case regular = "Poppins-Regular"
  case semiBold = "Poppins-SemiBold"
  case thin = "Poppins-Thin"
}
extension UIFont {
  static func setFont(fontType: CustomFont,
            fontSize: CustomFontSize) -> UIFont {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return UIFont(name: fontType.rawValue, size: fontSize.rawValue + fontSize.rawValue) ?? UIFont() } else {
        return UIFont(name: fontType.rawValue, size: fontSize.rawValue) ?? UIFont()
      }
  }
}
