//
//  WellnessConstants.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 13/06/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func getGroupCode() -> String {
        //Get Group Info
        var groupCode = ""
        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
        if groupMasterArray.count > 0 {
            groupCode = groupMasterArray[0].groupCode!
            return groupCode
        }
        return groupCode
    }
    
}

extension Date {
    func getDateStrdd_mmm_yy() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: self)
    }
    
    
}

extension String {
    func getDatefromddMMyyyy() -> Date {
        if self != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            //formatter.timeZone = TimeZone(abbreviation: "GMT")
            
            let olddate = formatter.date(from: self)
            return olddate ?? Date()
        }
        return Date()
    }
}


extension UIButton {
    //CircularButton with green color used from nursing
    func makeHHCButton() {
        self.dropShadow()
        //self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.cornerRadius = 6.0
        self.backgroundColor = Color.buttonBackgroundGreen.value
        self.layer.borderColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1) //3ED9B1
        self.setTitleColor(UIColor.white, for: .normal)
        self.isUserInteractionEnabled = true
    }
    
    func makeHHCCircularButton() {
        self.dropShadow()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.backgroundColor = Color.buttonBackgroundGreen.value
    }

    
    //Used in wellness nursing select options
    func makeRoundedBorderGreen() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1) //3ED9B1
        //self.layer.borderColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1) //40e0d0

        self.layer.borderWidth = 1.0
        //self.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.backgroundColor = Color.buttonBackgroundGreen.value
        self.setTitleColor(UIColor.white, for: .normal)
    
       // self.setTitleColor(Color.buttonBackgroundGreen.value, for: .normal)
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true

    }
    
    func makeRoundedBorderGreenWithWhiteBackground() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1) //3ED9B1
        self.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1) //3ED9B1
        
        //self.layer.borderColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1) //40e0d0
        //self.layer.borderColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1) //40e0d0
        
        self.layer.borderWidth = 1.0
        //self.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.backgroundColor = UIColor.white
        self.setTitleColor(Color.buttonBackgroundGreen.value, for: .normal)
    
       // self.setTitleColor(Color.buttonBackgroundGreen.value, for: .normal)
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }

    
    func makeRoundedBorderGray() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.layer.borderWidth = 1.0
        self.titleLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }
    
    func disabledButton() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.layer.borderWidth = 1.0
        self.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        //self.layer.cornerRadius = 6.0
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false

    }
}


extension UITextField {
    func makeRoundedBorderGreen() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        //self.layer.borderColor = #colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.4274509804, alpha: 1)
        self.layer.borderColor = Color.buttonBackgroundGreen.value.cgColor
        self.layer.borderWidth = 1.0
        self.textColor = Color.buttonBackgroundGreen.value
        //self.setTitleColor(Color.buttonBackgroundGreen.value, for: .normal)
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
    }
}


class ConstantAPICallMD : NSObject {
    static let sharedInstance = ConstantAPICallMD()
    
    func getNewToken_MD(view:UIViewController) {
        print("Get new token For MD")
        let URL = APIEngine.shared.getTokenForMDURL()
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: URL, view: view) { (response, error) in
                            
            if let status = response?["Status"].bool
                {
                    if status == true {
                        if let token = response?["Token"].string {
                            UserDefaults.standard.set(token, forKey: "tokenMD")
                        }
                    }
                    else {
                        //employee record not found
                        //let msg = messageDictionary["Message"]?.string
                        UserDefaults.standard.set(nil, forKey: "tokenMD")

                        view.displayActivityAlert(title: m_errorMsg )
                    }
                }
        }
    }
}
