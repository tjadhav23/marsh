//
//  ColorScheme.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 01/07/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import Foundation
import UIKit

// Usage Examples
//let shadowColor = Color.shadow.value
//let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)
//let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 0.25).value

enum Color {
    
    //    case theme
    //    case border
    //    case shadow
    
    //case darkBackground
    //case lightBackground
    //case intermidiateBackground
    
    case buttonBackgroundGreen
    
    //case darkText
    //case lightText
    //case intermidiateText
    
    //case affirmation
    //case negation
    
    case custom(hexString: String, alpha: Double)
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
    case dark_grey
    case insuranceThemeColor
    //Greeen Gradient Color
    case greenTop
    case greenBottom
    case fontColor
    case textDarkGreen
    case bottomColor
    case redFont
    
    //Red Gradient Color
    case redTop
    case redBottom
    case tabBarBottomColor
    
    case fitnessTop
    case fitnessBottom
    
    case backgroundLightGrayShade
    
    
    //Pinc Application Color
    case pinc_PrimaryColor
    case pinc_SecondryColor
    case pinc_LabelPrimaryColor
    case pinc_LabelSecondryColor
    case pinc_QueryDetailsPageBgColor
    case pinc_titleBgColor
    case Error_ViewBgColor
    case Error_BgColor
}

extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .insuranceThemeColor:
            instanceColor = UIColor(hexString: "#203368")
            // case .border:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .theme:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .shadow:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .darkBackground:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .lightBackground:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .intermidiateBackground:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .darkText:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .intermidiateText:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .lightText:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .affirmation:
            //            instanceColor = UIColor(hexString: "#000000")
            //        case .negation:
            //            instanceColor = UIColor(hexString: "#000000")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
            
        case .greenTop:
            //instanceColor = UIColor(hexString: "#0bea81")
            instanceColor = UIColor(hexString: "#3ed9b1")
            
        case .greenBottom:
            //instanceColor = UIColor(hexString: "#0cc46d")
            instanceColor = UIColor(hexString: "#40e0d0")
            
        case .buttonBackgroundGreen:
            // instanceColor = UIColor(hexString: "#0cc46d")
            
            instanceColor = UIColor(hexString: "#3ed9b1")
            //instanceColor = UIColor(hexString: "#40e0d0")
            
        case.fontColor: //textGreen
            instanceColor = UIColor(hexString: "#04B360")
            //instanceColor = UIColor.red
           
        case .dark_grey:
            instanceColor = UIColor(hexString: "#969696")
            //Dark Red
            //case .redTop:
            // instanceColor = UIColor(hexString: "#f02a03")
            
            //case .redBottom:
            // instanceColor = UIColor(hexString: "#fc7b62")
            
            //Dark Red
        case .redFont:
            instanceColor = UIColor(hexString: "#f02a03")
            
            //Orange
        case .redTop:
            instanceColor = UIColor(hexString: "#ffbb3d")
            
        case .redBottom:
            instanceColor = UIColor(hexString: "#ff8f26")
            
            //        case .redTop:
            //            instanceColor = UIColor(hexString: "#F5FAFF")
            //
            //        case .redBottom:
            //            instanceColor = UIColor(hexString: "#BFE1FD")
            
            
            //Sky Blue
        case .fitnessTop:
            instanceColor = UIColor(hexString: "#F5FAFF")
            
        case .fitnessBottom:
            instanceColor = UIColor(hexString: "#BFE1FD")
            
            
        case .textDarkGreen:
            instanceColor = UIColor(hexString: "#0BC96F")
        case .bottomColor:
            instanceColor = UIColor(hexString: "#71C252")
        case .tabBarBottomColor:
            instanceColor = UIColor(hexString: "#F2FCF7")
            
            
        case .backgroundLightGrayShade:
            instanceColor = UIColor(hexString: "#E6E6E6")
            
            
        //PINC Colors
        case .pinc_PrimaryColor:
            instanceColor = UIColor(hexString: "#E2046E")
            
        case .Error_ViewBgColor:
            instanceColor = UIColor(hexString: "#e7505a")
            
        case .pinc_SecondryColor:
            instanceColor = UIColor(hexString: "#FF1000")
            
        case .pinc_LabelPrimaryColor:
            instanceColor = UIColor(hexString: "#086315")
            
        case .pinc_LabelSecondryColor:
            instanceColor = UIColor(hexString: "#E7BE2A")
            
        case .pinc_QueryDetailsPageBgColor:
            instanceColor = UIColor(hexString: "#f8f9fa")
            
        case .pinc_titleBgColor:
            instanceColor = UIColor(hexString: "#D9D9D9")
            
            
        case .Error_BgColor:
            instanceColor = UIColor(hexString: "#fef7f8")
        }
        
        
        return instanceColor
    }
}
/*
 <color name="textdarkgreen">#0BC96F</color> same family details price
 <color name="textgreen">#04B360</color> Font Color All fonts
 #0cc46d // All buttons and view background color
 */

extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     
     - returns: UIColor from HexString
     */
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
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}


extension UIView {
    
    func setGradientBackgroundCA(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
