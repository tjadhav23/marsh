//
//  FontsConstant.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 13/11/22.
//  Copyright © 2022 Semantic. All rights reserved.

//Font channges for Insurence

import Foundation

class FontsConstant: NSObject {
    
    static let shared = FontsConstant()
    
    //Fonts
    let OpenSansRegular = "NotoSans-Medium"
    let OpenSansMedium = "NotoSans-Medium"
    let OpenSansBold = "NotoSans-Bold"
    let OpenSansLight = "NotoSans-Light"
    let OpenSansSemiBold = "NotoSans-SemiBold"
    let NotoSansRegular = "NotoSans-Regular"
    
    let regular = "NotoSans-Medium"
    let medium = "NotoSans-Medium"
    let bold = "NotoSans-Bold"
    let light = "NotoSans-Light"
    let semiBold = "NotoSans-SemiBold"
    
    let hDayCount = 58
    let headerSize30 = 30
    let contentSize25 = 25
    let h24 = 24
    let h20 = 20
    let h19 = 19
    let h18 = 18
    let h17 = 17
    let h16 = 16
    let h15 = 15
    let h14 = 14
    let h13 = 13
    let h12 = 12
    let h10 = 10
    let h09 = 09
    let h08 = 08
    
    
    let app_FontBlackColor = UIColor.black //Black
    let app_FontPrimaryColor = UIColor(hexString: "#002C77") //Dark Blue
    let app_FontSecondryColor = UIColor(hexString: "#909090") //Grey
    
    let app_FontDarkGreyColor = UIColor(hexString: "#565656") //Dark Grey
    
    let app_FontAppColor = UIColor(hexString: "#009DE0") //light blue Grey
    let app_ViewBGColor = UIColor(hexString: "#D9D9D9")
    
    let app_ViewBGColor2 = UIColor(hexString: "#F2F6FF")
    let app_lightGrayColor = UIColor(hexString: "#6A7381") //light gray
    let app_mediumGrayColor = UIColor(hexString: "#969696") //MEDIUM gray
    
    let app_WhiteColor = UIColor(hexString: "#FFFFFF") //MEDIUM gray
    let app_BlueHyperlinkColor = UIColor(hexString: "#007BFF") //light blue
    
    let app_FontMarronColor = UIColor(hexString: "#622140") //Marron
    
    let app_ButtonBGColor = UIColor(hexString: "#feb4d8") //light pink
    
    
    let app_ErrorColor = UIColor(hexString: "#e7505a") //red
    
    let app_FontCaribbeanGreen =  UIColor(hexString: "#00CC99")
    let app_FontLightGreyColor = UIColor(hexString: "#C2C2C2") //LIGHT Grey
    let app_BlueColor = UIColor(hexString: "#0171d5")
    let app_errorTitleColor = UIColor(hexString: "#C2C2C2")
    //let app_errorTitleColor = UIColor(hexString: "#6A7381")
    
    let HosptailLblPrimary = UIColor(hexString: "#002C77") //DarkBlue
    let HosptailLblSecondary = UIColor(hexString: "#00968F") //Green
    let HosptailLblTertiary = UIColor(hexString: "#8246AF") //purple
    let HosptailLblOther = UIColor(hexString: "#EE3D8B") //pink
    let HosptailBtnBG = UIColor(hexString: "#e6f2ff") //light blue
    let corporate = UIColor(hexString: "#EAC645") //light yello
    
}


extension String {

    var removeSpecialChars: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890._[]-,/")
        return self.filter {okayChars.contains($0) }
    }
}
