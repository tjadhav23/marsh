// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getClaimNo = try? JSONDecoder().decode(GetClaimNo.self, from: jsonData)

import Foundation

// MARK: - GetClaimNo
struct GetClaimNo: Codable {
    let id: String
    let employeeClaimsValues: EmployeeClaimsValues
    let claimInformation: [ClaimInformation]
    let message: MessageGetClaimNo

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case employeeClaimsValues = "EmployeeClaimsValues"
        case claimInformation = "ClaimInformation"
        case message
    }
}

// MARK: - ClaimInformation
struct ClaimInformation: Codable {
    let id, beneficiary, personSrNo, claimNo: String
    let claimDate, fir, claimSrNo, relationWithEmployee: String
    let claimStatus, age, gender, dateOfBirth: String
    let cellphoneNumber: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case beneficiary = "BENEFICIARY"
        case personSrNo = "PERSON_SR_NO"
        case claimNo = "CLAIM_NO"
        case claimDate = "CLAIM_DATE"
        case fir = "FIR"
        case claimSrNo = "CLAIM_SR_NO"
        case relationWithEmployee = "RELATION_WITH_EMPLOYEE"
        case claimStatus = "CLAIM_STATUS"
        case age = "AGE"
        case gender = "GENDER"
        case dateOfBirth = "DATE_OF_BIRTH"
        case cellphoneNumber = "CELLPHONE_NUMBER"
    }
}

// MARK: - EmployeeClaimsValues
struct EmployeeClaimsValues: Codable {
    let id, employeeSrNo, oeGrpBasInfSrNo: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case employeeSrNo = "EMPLOYEE_SR_NO"
        case oeGrpBasInfSrNo = "OE_GRP_BAS_INF_SR_NO"
    }
}

// MARK: - Message
struct MessageGetClaimNo: Codable {
    let id, message: String
    let status: Bool
    let responseData: JSONNullMessageGetClaimNo?

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case message = "Message"
        case status = "Status"
        case responseData = "ResponseData"
    }
}

// MARK: - Encode/decode helpers

class JSONNullMessageGetClaimNo: Codable, Hashable {

    public static func == (lhs: JSONNullMessageGetClaimNo, rhs: JSONNullMessageGetClaimNo) -> Bool {
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
