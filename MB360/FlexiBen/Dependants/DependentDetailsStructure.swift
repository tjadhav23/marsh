//
//  DependentDetailsStructure.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 02/09/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation

// MARK: - GetPackagePriceElement
struct DependentDetailsStructureNestedJSONModel: Codable {
    var Dependent: [Dependent]
}

struct Dependent: Codable {
    var name, relation, gender, relationID: String?
    var age, dateOfBirth, personSrNo: String?
    var employeeSrNo: String?
    var isSelected, isApplicable, canDelete: Bool?
    var reasonForNotAbleToDelete: String?
    var canUpdate: Bool?
    var isTwins: String?
    var reasonForNotAbleToUpdate: String?
    var isDisabled: Bool?
    var pairNo: String?
    var extraChildPremium, isParentOpted, premium, sumInsured: String?
    var aadharNo, groupChildSrNo: String?
    var parentalPremiuimSeparate, baseSI: Int?
    var oeGrpBasInfSrNo: String?
    var index : Int?
    var minAge : String = "18"
    var maxAge : String = "60"

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case relation = "Relation"
        case gender = "Gender"
        case relationID = "RelationID"
        case age = "Age"
        case dateOfBirth = "DateOfBirth"
        case personSrNo = "PersonSrNo"
        case employeeSrNo = "EmployeeSrNo"
        case isSelected = "IsSelected"
        case isApplicable = "IsApplicable"
        case canDelete = "CanDelete"
        case reasonForNotAbleToDelete = "ReasonForNotAbleToDelete"
        case canUpdate = "CanUpdate"
        case isTwins = "IsTwins"
        case reasonForNotAbleToUpdate = "ReasonForNotAbleToUpdate"
        case isDisabled = "IsDisabled"
        case pairNo = "PairNo"
        case extraChildPremium = "ExtraChildPremium"
        case isParentOpted = "IsParentOpted"
        case premium = "Premium"
        case sumInsured = "SumInsured"
        case aadharNo = "AadharNo"
        case groupChildSrNo = "GroupChildSrNo"
        case parentalPremiuimSeparate = "ParentalPremiuimSeparate"
        case baseSI = "BaseSI"
        case oeGrpBasInfSrNo = "OeGrpBasInfSrNo"
    }
}

typealias GetPackagePrice = [DependentDetailsStructureNestedJSONModel]

// MARK: - Encode/decode helpers

class JSONNull_DependentDetailsStructureNestedJSONModel: Codable, Hashable {

    public static func == (lhs: JSONNull_DependentDetailsStructureNestedJSONModel, rhs: JSONNull_DependentDetailsStructureNestedJSONModel) -> Bool {
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


//struct DependentDetailsStructureNestedJSONModel: Codable {
//    var Dependent: [Dependent]
//}
//
//struct Dependent: Codable {
//    var SrNo:Int?
//    var Name: String?
//    var Relation: String?
//    var Gender: String?
//    var RelationID: String?
//    var Age: String?
//    var DateOfBirth: String?
//    var PersonSrNo: String?
//    var ReasonForNotAbleToDelete: String?
//    var IsTwins: String?
//    var ReasonForNotAbleToUpdate: String?
//    var PairNo: String?
//    var ExtraChildPremium: String?
//    var Premium:String?
//    var document: String?
//    var IsSelected: Bool?
//    var IsApplicable: Bool?
//    var CanDelete: Bool?
//    var CanUpdate: Bool?
//    var IsDisabled: Bool?
//    var isAdded: Bool?
//
//
//
//    init(){
//        SrNo = -1
//        Name = ""
//        Relation = ""
//        Gender = ""
//        RelationID = ""
//        Age = ""
//        DateOfBirth = ""
//        PersonSrNo = ""
//        ReasonForNotAbleToDelete = ""
//        IsTwins = ""
//        ReasonForNotAbleToUpdate = ""
//        PairNo = ""
//        ExtraChildPremium = ""
//        Premium = ""
//        document = ""
//        IsSelected = false
//        IsApplicable = false
//        CanDelete = false
//        CanUpdate = false
//        IsDisabled = false
//        isAdded = true
//    }

   /* enum CodingKeys: String, CodingKey {
        case SrNo
        case Name
        case Relation
        case Gender
        case RelationID
        case Age
        case DateOfBirth
        case PersonSrNo
        case IsSelected
        case IsApplicable
        case CanDevare
        case ReasonForNotAbvaroDevare
        case CanUpdate
        case IsTwins
        case ReasonForNotAbvaroUpdate
        case IsDisabled
        case PairNo
        case ExtraChildPremium
        case Premium
        case document
    } */
//}

