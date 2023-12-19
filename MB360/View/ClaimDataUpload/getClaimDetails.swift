// This file was generated from JSON Schema using codebeautify, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getClaimDetails = try getClaimDetails(json)

import Foundation



// MARK: - GetClaimDetails
struct GetClaimDetails: Codable {
    let id: String
    let detail: [DetailGetClaimDetails]
    let result: Result

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case detail = "Detail"
        case result = "Result"
    }
}

// MARK: - Detail
struct DetailGetClaimDetails: Codable {
    let id, personName, personSrNo, dateOfBirth: String
    let relationName: JSONNullGetClaimDetails?
    let relationID, cellphoneNumber, age, gender: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case personName = "PERSON_NAME"
        case personSrNo = "PERSON_SR_NO"
        case dateOfBirth = "DATE_OF_BIRTH"
        case relationName = "RELATION_NAME"
        case relationID = "RELATION_ID"
        case cellphoneNumber = "CELLPHONE_NUMBER"
        case age = "AGE"
        case gender = "GENDER"
    }
}

// MARK: - Result
struct Result: Codable {
    let id, message: String
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case message = "Message"
        case status = "Status"
    }
}

// MARK: - Encode/decode helpers

class JSONNullGetClaimDetails: Codable, Hashable {

    public static func == (lhs: JSONNullGetClaimDetails, rhs: JSONNullGetClaimDetails) -> Bool {
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




// MARK: - GetDocDetails
struct GetDocDetails: Codable {
    let id: String
    let detail: [DetailDoc]
    let result: ResultDoc

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case detail = "Detail"
        case result = "Result"
    }
}

// MARK: - DetailDoc
struct DetailDoc: Codable {
    var id, clmDocName, clmDocDescription: String
    var clmReqDocsSrNo, isDocMandatory, isDocToInclInCommMail: Int
    var isEdit : Bool = false
    var fileName : String? = ""
    var remark : String? = ""
    var count : Int? = 0
    var fileUrl : URL? = nil
    var originalFileName : String? = ""
    var isDisabled : Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case clmDocName = "CLM_DOC_NAME"
        case clmDocDescription = "CLM_DOC_DESCRIPTION"
        case clmReqDocsSrNo = "CLM_REQ_DOCS_SR_NO"
        case isDocMandatory = "IS_DOC_MANDATORY"
        case isDocToInclInCommMail = "IS_DOC_TO_INCL_IN_COMM_MAIL"
    }
}

// MARK: - Result
struct ResultDoc: Codable {
    let id, message: String
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case message = "Message"
        case status = "Status"
    }
}
