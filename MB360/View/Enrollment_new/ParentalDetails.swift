//
//  ParentalDetails.swift
//  MyBenefits360
//
//  Created by home on 08/12/22.
//  Copyright © 2022 Semantic. All rights reserved.
//
/*
import Foundation

struct ParentalRecordsNestedJSONModel: Codable {
    var parentalRecordsArray : [ParentalRecords]
}


struct ParentalRecords: Codable {
    var SrNo:Int?
    var Name: String?
    var Relation: String?
    var Gender: String?
    var RelationID: String?
    var Age: String?
    var DateOfBirth: String?
    var PersonSrNo: String?
    var ReasonForNotAbleToDelete: String?
    var IsTwins: String?
    var ReasonForNotAbleToUpdate: String?
    var PairNo: String?
    var ExtraChildPremium: String?
    var Premium:String?
    var document: String?
    var enrollment_Reason : String?
    var parentPercentage : Double = 0.0
    var IsSelected: Bool?
    var IsApplicable: Bool?
    var CanDelete: Bool?
    var CanUpdate: Bool?
    var IsDisabled: Bool?
    var isAdded: Bool?
}
*/

import Foundation

// MARK: - ParentalRelation
struct ParentalRelation: Codable {
    let availPaernts: [AvailPaernt]
    let empGender: [String]
    let empCanCover: [EmpCanCover]
    let isCrossCombinationAllowed: [String]

    enum CodingKeys: String, CodingKey {
        case availPaernts = "AvailPaernts"
        case empGender = "EmpGender"
        case empCanCover = "EmpCanCover"
        case isCrossCombinationAllowed = "IsCrossCombinationAllowed"
    }
}

// MARK: - AvailPaernt
struct AvailPaernt: Codable {
    let relationID, relation: String

    enum CodingKeys: String, CodingKey {
        case relationID = "RELATION_ID"
        case relation = "RELATION"
    }
}

// MARK: - EmpCanCover
struct EmpCanCover: Codable {
    let canFemlCovrParents, canMlCovrParents, canFemlCovrInlaws, canMlCovrInlaws: Int

    enum CodingKeys: String, CodingKey {
        case canFemlCovrParents = "CAN_FEML_COVR_PARENTS"
        case canMlCovrParents = "CAN_ML_COVR_PARENTS"
        case canFemlCovrInlaws = "CAN_FEML_COVR_INLAWS"
        case canMlCovrInlaws = "CAN_ML_COVR_INLAWS"
    }
}


// MARK: - ParentalRecord
struct ParentalRecords: Decodable {
    var premium: String
    var premiumType, sumInsured, siType: String?
    var personSrNo, name, age, dateOfBirthToShow: String
    var dateOfBirth, relation, relationID: String
    var covered, canAdd, canUpdate, canDelete: Bool
    var canInclude: Bool
    var reason: String
    var coveredInPolicyType: Int
    var employerContri, employeeContri: String?
    var parentsBaseSumInsured, sortNo: String

    enum CodingKeys: String, CodingKey {
        case premium = "Premium"
        case premiumType = "PremiumType"
        case sumInsured = "SumInsured"
        case siType = "SiType"
        case personSrNo = "PersonSrNo"
        case name = "Name"
        case age = "Age"
        case dateOfBirthToShow = "DateOfBirthToShow"
        case dateOfBirth = "DateOfBirth"
        case relation = "Relation"
        case relationID = "RelationId"
        case covered = "Covered"
        case canAdd = "CanAdd"
        case canUpdate = "CanUpdate"
        case canDelete = "CanDelete"
        case canInclude = "CanInclude"
        case reason = "Reason"
        case coveredInPolicyType = "CoveredInPolicyType"
        case employerContri = "EmployerContri"
        case employeeContri = "EmployeeContri"
        case parentsBaseSumInsured = "ParentsBaseSumInsured"
        case sortNo = "SortNo"
    }
}


typealias ParentalRecord = [ParentalRecords]

// MARK: - Encode/decode helpers

class JSONNull_ParentalRecords: Codable, Hashable {

    public static func == (lhs: JSONNull_ParentalRecords, rhs: JSONNull_ParentalRecords) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
