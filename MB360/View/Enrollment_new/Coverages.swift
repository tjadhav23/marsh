//
//  Coverages.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 17/08/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation

struct CoveragesNestedJSONModel: Codable {
    let coverages: [Coverage]
    enum CodingKeys: String, CodingKey {
        case coverages
    }
}


struct Coverage: Codable{
    
    var policy_type: String
    var type_of_policy: String
    var sum_insured: String
    var sum_insure_type: String
    var premium: String
    var premium_type: String
    var to_show_premium: String
    var how_to_show_sum_insured: String
    var employer_contribution: String
    var employee_contribution: String
    var to_show_employee_contribution: String
    var to_show_employer_contribution: String
    var instruction: String
    
    
    enum CodingKeys: String, CodingKey {
           case policy_type
        case type_of_policy
        case sum_insured
        case sum_insure_type
        case premium
        case premium_type
        case to_show_premium
        case how_to_show_sum_insured
        case employer_contribution
        case employee_contribution
        case to_show_employee_contribution
        case to_show_employer_contribution
        case instruction
    }
}
