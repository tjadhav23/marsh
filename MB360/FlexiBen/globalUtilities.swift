//
//  globalUtilities.swift
//  MyBenefits360
//
//  Created by home on 07/12/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation



func getCurrentDate() -> Date{
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let date = Date()
    let dateString = dateFormatter.string(from: date)
   let currentDate = dateFormatter.date(from: dateString)
    return currentDate!
    
    
}

func setTintofBtnImg(_ btn: UIButton,color: UIColor,img: String){
    let image = UIImage(named: img)?.withRenderingMode(.alwaysTemplate)
    btn.setImage(image, for: .normal)
    btn.tintColor = color
}

func setImgTintColor(_ img: UIImageView,color: UIColor){
    let template = img.image?.withRenderingMode(.alwaysTemplate)
    img.image = template
    img.tintColor = color
}

var globalHospitalList = [[String: String]]()
var GlobalendDate = "31-12-2022"
var GlobalGPAendDate = "31-12-2022"
var GlobalGTLendDate = "31-12-2022"

var isWithOtp : Bool = true //False for not sending otp
