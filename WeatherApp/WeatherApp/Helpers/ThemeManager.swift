//
//  ThemeManager.swift
//  
//
//  Created by Ramamoorthy on 28/04/23.
//

import Foundation
import UIKit

enum Color: String {
    
    typealias RawValue = String
    
    
    case primaryColor  = "PrimaryColor"
    case primaryLabelColor = "PrimaryLabelColor"
    case backgroundColor = "BackgroundColor"
    case navigationBarLabelColor = "NavigationBarLabelColor"
    case destructiveMsgColor = "DestructiveMsgColor"
    case lightGrayColor = "LightGrayColor"
    case white="white"
    case black="black"
    case linkColor = "linkColor"
    case darkGrayColor = "darkGrayColor"
    case shadowColor = "shadowColor"
    case placeHolderColor = "placeHolderColor"
    case headLabelColor = "headLabelColor"
    case borderColor = "borderColor"
    case greenColor = "greenColor"
    case separatorColor = "separatorColor"
    case cardBgColor = "cardBgColor"
    case buttonDisabledColor = "buttonDisabledColor"
    case hashTagBackground = "hashTagBackground"
    case blockColor = "blockColor"
    case reportColor = "reportColor"
    case loadingIndicator = "loadingIndicator"
    case saveProdPrice = "saveProdPrice"
    case filterHeader = "filterHeader"
    case chartTopGradient = "chartTopGradient"
    case textViewPlaceholderColor = "textViewPlaceholderColor"
    case deleteSwipeColor = "deleteSwipeColor"
    case chatTextViewPlaceholderColor = "chatTextViewPlaceholderColor"
    case chatBubbleReceived = "chat_bubble_color_received"
    case chatBubbleSent = "chat_bubble_color_sent"
    case selectedProductbg = "selectedProductbg"
    case buttonBGGreen = "buttonBGGreen"
    case unreadBGColor = "unreadBGColor"
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        switch self {
        case .primaryColor:
            if #available(iOS 13, *) {
                instanceColor =  UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return UIColor.init(hexString: "#707070")
                    } else {
                        return UIColor(hexString: "#707070")
                    }
                }
            } else {
                instanceColor = UIColor(hexString: "#707070")
            }
            
        case .primaryLabelColor:
            if #available(iOS 13, *) {
                instanceColor =  UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .white
                    } else {
                        return .black
                    }
                }
            } else {
                instanceColor = .black
            }
            
        case .backgroundColor:
            instanceColor = UIColor.init(hexString: "#223057")
           
        case .navigationBarLabelColor:
            instanceColor = UIColor.white
            
        case .destructiveMsgColor:
            instanceColor = UIColor.red
            
        case .lightGrayColor:
            instanceColor = UIColor.lightGray
            case .white:
                       instanceColor = UIColor(hexString: "#ffffff")
            case .black:
                if #available(iOS 13, *) {
                instanceColor =  UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .dark {
                            return UIColor.init(hexString: "#000000")
                        } else {
                                   return UIColor(hexString: "#000000")
                               }
                           }
                       } else {
                           instanceColor = UIColor(hexString: "#000000")
                       }
        case .linkColor:
            instanceColor = UIColor(hexString: "#007AFF")
        case .darkGrayColor:
            instanceColor = UIColor(hexString: "#343434")
        case .shadowColor:
            instanceColor = UIColor(hexString: "#0000005C")
        case .placeHolderColor:
            instanceColor = UIColor(hexString: "#909090")//#C7C7CD
        case .headLabelColor:
            instanceColor = UIColor(hexString: "#AEAEB2")
        case .borderColor:
            instanceColor = UIColor(hexString: "#C0C0C0")
        case .greenColor:
            instanceColor = UIColor(hexString: "#88B52D")
        case .separatorColor:
            instanceColor = UIColor(hexString: "#EFEFEF")
        case .cardBgColor:
            instanceColor = UIColor(hexString: "#1B2441")
        case .buttonDisabledColor:
            instanceColor = UIColor(hexString: "#ADADAD")
        case .hashTagBackground:
            instanceColor = UIColor(hexString: "#2C5879")
        case .blockColor:
            instanceColor = UIColor(hexString: "#5959D3")
        case .reportColor:
            instanceColor = UIColor(hexString: "#FF0707")
        case .loadingIndicator:
            instanceColor = UIColor(hexString: "#00BB56")
        case .saveProdPrice :
            instanceColor = UIColor(hexString: "#1F8E0A")
        case .filterHeader :
            instanceColor = UIColor(hexString: "#686967")
        case .chartTopGradient:
            instanceColor = UIColor(hexString: "#55D8FE")
        case .textViewPlaceholderColor:
            instanceColor = UIColor(hexString: "#B4B0B0")
        case .deleteSwipeColor:
            instanceColor = UIColor(hexString: "#07B3FF")
        case .chatTextViewPlaceholderColor:
            instanceColor = UIColor(hexString: "#BABABA")
        case .chatBubbleReceived:
            instanceColor = UIColor(hexString: "#C2FFCF")
        case .chatBubbleSent:
            instanceColor = UIColor(hexString: "#C2EEFF")
        case .selectedProductbg:
            instanceColor = UIColor(hexString: "#333333")
        case .buttonBGGreen:
            instanceColor = UIColor(hexString: "#408348")
        case .unreadBGColor:
            instanceColor = UIColor(hexString: "#E1EEDA")
        }
        
        return instanceColor
    }
    
}

extension UIColor {
    
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: red, green: green, blue: blue, alpha: 1)
        } else {
            self.init(red: red, green: green, blue: blue, alpha: 1)
        }
        
        //self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

enum Font: String {
    
    typealias RawValue = String
    
    case LargeTitle = "LargeTitle"
    case Title1 = "Title1"
    case Title2 = "Title2"
    case Title2Medium = "Title2Medium"
    case Title3 = "Title3"
    case Headline  = "Headline"
    case Body = "Body"
    case Footnote = "Footnote"
    case Caption1 = "Caption1"
    case Caption2 = "Caption2"
    case Subhead = "Subhead"
    case SubheadBold = "SubheadBold"
    case Callout = "Callout"
    case Footnote2 = "Footnote2"
    case Title3SBold = "Title3SBold"
    case Title1SBold = "Title1SBold"
    case SubheadReg = "SubheadReg"
    case priceLargeFont = "priceLargeFont"
    case priceSmallFont = "priceSmallFont"
    case priceNormalFont = "priceNormalFont"
    
    var value: UIFont {
        var instanceFont = UIFont.systemFont(ofSize: 17)
        switch self {
        case .LargeTitle:
            instanceFont = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.regular)
        case .Title1:
            instanceFont = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.regular)
        case .Title1SBold:
            instanceFont = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.semibold)
        case .Title2:
            instanceFont = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.regular)
        case .Title2Medium:
            instanceFont = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        case .Title3:
            instanceFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        case .Title3SBold:
            instanceFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        case .Headline:
            instanceFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        case .Body:
            instanceFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        case .Subhead:
            instanceFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        case .SubheadBold:
             instanceFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        case .SubheadReg:
            instanceFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        case .Footnote:
            instanceFont = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        case .Footnote2:
            instanceFont = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        case .Caption1:
            instanceFont = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        case .Caption2:
            instanceFont = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        case .Callout:
            instanceFont = UIFont.preferredFont(forTextStyle: .callout)
        case .priceLargeFont:
            instanceFont = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        case .priceSmallFont:
            instanceFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        case .priceNormalFont:
            instanceFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        }
        return instanceFont
    }
    
}


class GrediantColor {
    let colorTop = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0)
    let colorBottom = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    let gl: CAGradientLayer
    
    init() {
        gl = CAGradientLayer()
        gl.colors = [ colorTop, colorBottom]
        gl.locations = [ 0.0, 1.0]
    }
}
