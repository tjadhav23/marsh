// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getClaimValues = try? JSONDecoder().decode(GetClaimValues.self, from: jsonData)

import Foundation

// MARK: - GetClaimValues
struct GetClaimValues: Codable {
    let employeeClaimsValues: EmployeeClaimsValues
    let claimInformation: [ClaimInformation]
    let message: MessageGetClaimValues

    enum CodingKeys: String, CodingKey {
        case employeeClaimsValues = "EmployeeClaimsValues"
        case claimInformation = "ClaimInformation"
        case message
    }
}

// MARK: - ClaimInformation
struct ClaimInformation: Codable {
    let beneficiary, claimNo, claimDate, claimAmt: String
    let claimType, claimSrNo, relationWithEmployee, claimStatus: String

    enum CodingKeys: String, CodingKey {
        case beneficiary = "BENEFICIARY"
        case claimNo = "CLAIM_NO"
        case claimDate = "CLAIM_DATE"
        case claimAmt = "CLAIM_AMT"
        case claimType = "CLAIM_TYPE"
        case claimSrNo = "CLAIM_SR_NO"
        case relationWithEmployee = "RELATION_WITH_EMPLOYEE"
        case claimStatus = "CLAIM_STATUS"
    }
}

// MARK: - EmployeeClaimsValues
struct EmployeeClaimsValues: Codable {
    let employeeSrNo, oeGrpBasInfSrNo: String

    enum CodingKeys: String, CodingKey {
        case employeeSrNo = "EMPLOYEE_SR_NO"
        case oeGrpBasInfSrNo = "OE_GRP_BAS_INF_SR_NO"
    }
}

// MARK: - Message
struct MessageGetClaimValues: Codable {
    let message: String
    let status: Bool
    let responseData: JSONNullGetClaimValues?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case responseData = "ResponseData"
    }
}

// MARK: - Encode/decode helpers

class JSONNullGetClaimValues: Codable, Hashable {

    public static func == (lhs: JSONNullGetClaimValues, rhs: JSONNullGetClaimValues) -> Bool {
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
