// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getIntimationNo = try? JSONDecoder().decode(GetIntimationNo.self, from: jsonData)

import Foundation

// MARK: - GetIntimationNo
struct GetIntimationNo: Codable {
    let id: String
    let detail: [GetIntimationNoDetail]
    let result: ResultGetIntimationNo

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case detail = "Detail"
        case result = "Result"
    }
}

// MARK: - GetIntimationNoDetail
struct GetIntimationNoDetail: Codable {
    let id, claimName, clmIntSrNo, claimIntimationNo: String
    let intimationDetails: IntimationDetails

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case claimName = "CLAIM_NAME"
        case clmIntSrNo = "CLM_INT_SR_NO"
        case claimIntimationNo = "CLAIM_INTIMATION_NO"
        case intimationDetails = "IntimationDetails"
    }
}

// MARK: - IntimationDetails
struct IntimationDetails: Codable {
    let id: String
    let detail: [IntimationDetailsDetail]
    let result: Result

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case detail = "Detail"
        case result = "Result"
    }
}

// MARK: - IntimationDetailsDetail
struct IntimationDetailsDetail: Codable {
    let id: String
    let personName: String
    let personSrNo: String
    let dateOfBirth: String
    let relationName: JSONNullGetIntimationNo?
    let relationID, cellphoneNumber, age: String
    let gender: String

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
struct ResultGetIntimationNo: Codable {
    let id: String
    let message: MessageGetIntimationNo
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case message = "Message"
        case status = "Status"
    }
}

enum MessageGetIntimationNo: String, Codable {
    case dataFetched = "Data Fetched"
}

// MARK: - Encode/decode helpers

class JSONNullGetIntimationNo: Codable, Hashable {

    public static func == (lhs: JSONNullGetIntimationNo, rhs: JSONNullGetIntimationNo) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNullGetIntimationNo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
