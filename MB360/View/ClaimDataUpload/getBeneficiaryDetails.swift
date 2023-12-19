// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getBeneficiaryDetails = try? JSONDecoder().decode(GetBeneficiaryDetails.self, from: jsonData)

import Foundation

// MARK: - GetBeneficiaryDetails
struct GetBeneficiaryDetails: Codable {
    let id: String
    let detail: [DetailGetBeneficiaryDetails]
    let result: ResultGetBeneficiaryDetails

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case detail = "Detail"
        case result = "Result"
    }
}

// MARK: - Detail
struct DetailGetBeneficiaryDetails: Codable {
    let id, personSrNo, personName, dateOfBirth: String
    let relationName: JSONNullGetBeneficiaryDetails?
    let relationID, cellphoneNumber, age, gender: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case personSrNo = "PERSON_SR_NO"
        case personName = "PERSON_NAME"
        case dateOfBirth = "DATE_OF_BIRTH"
        case relationName = "RELATION_NAME"
        case relationID = "RELATION_ID"
        case cellphoneNumber = "CELLPHONE_NUMBER"
        case age = "AGE"
        case gender = "GENDER"
    }
}

// MARK: - Result
struct ResultGetBeneficiaryDetails: Codable {
    let id, message: String
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case message = "Message"
        case status = "Status"
    }
}

// MARK: - Encode/decode helpers

class JSONNullGetBeneficiaryDetails: Codable, Hashable {

    public static func == (lhs: JSONNullGetBeneficiaryDetails, rhs: JSONNullGetBeneficiaryDetails) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNullGetBeneficiaryDetails.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
