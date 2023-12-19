//
//  Instructions.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 18/08/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation

struct InstructionsNestedJSONModel: Codable {
    let instructions: [Instructions]
    enum CodingKeys: String, CodingKey {
        case instructions
    }
}


struct Instructions: Codable{
    
    var Srno: Int
    var Grade: String
    var Designation: String
    var to_show_GRADE: String
    var to_show_DESIGNATION: String
    var InstructionText: String
    
    
    enum CodingKeys: String, CodingKey {
        case Srno
        case Grade
        case Designation
        case to_show_GRADE
        case to_show_DESIGNATION
        case InstructionText
    }
}
