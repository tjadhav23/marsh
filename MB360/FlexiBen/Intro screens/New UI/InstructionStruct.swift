//
//  InstructionStruct.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 14/08/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation

struct InstructionStruct{
    
    var srno : Int
    var grade : String
    var designation : String
    var instructionText : String
    
    init(srno: Int, grade: String,designation: String,instruction: String) {
        self.srno = srno
        self.grade = grade
        self.designation = designation
        instructionText = instruction
    }
}
