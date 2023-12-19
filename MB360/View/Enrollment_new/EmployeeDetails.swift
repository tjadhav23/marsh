//
//  EmployeeDetails.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 21/08/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation


struct Empolyee_DetailsNestedJSONModel: Decodable {
    var employee_details : [Employee_details]
}

struct Employee_details: Decodable {
    let Srno: String
    let FIELD_NAME: String
    let FIELD_VALUE: String
    let TO_DISPLAY: String
    let TO_EDITABLE: String
    let MANDATORY: String
    let TABLE_NAME: String
   // var isselected : Int?
    
}
