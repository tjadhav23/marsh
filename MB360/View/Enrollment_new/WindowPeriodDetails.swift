// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct WindowPeriodDetails: Decodable {
    let windowPeriod: WindowPeriod
    let message: Message
}

// MARK: - Message
struct Message: Decodable {
    let message: String
    let status: Bool
    let error: JSONNull?
}

// MARK: - WindowPeriod
struct WindowPeriod: Codable {
    let groupChildSrNo, oeGrpBasInfoSrNo, windowStartDate_gmc, windowStartDate_gpa,windowStartDate_gtl,windowEndDate_gmc,windowEndDate_gpa,windowEndDate_gtl: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
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
