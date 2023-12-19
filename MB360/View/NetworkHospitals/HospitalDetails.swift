// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getHospitalCount = try? JSONDecoder().decode(GetHospitalCount.self, from: jsonData)

import Foundation

// MARK: - GetHospitalCount
struct GetHospitalCount: Decodable {
    let hospitalCount: Int
    let message: MessageGetHospitalCount

    enum CodingKeys: String, CodingKey {
        case hospitalCount = "HospitalCount"
        case message
    }
}

// MARK: - Message
struct MessageGetHospitalCount: Decodable {
    let message: String
    let status: Bool
    let responseData: JSONNullMessageGetHospitalCount?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case responseData = "ResponseData"
    }
}

// MARK: - Encode/decode helpers

class JSONNullMessageGetHospitalCount: Codable, Hashable {

    public static func == (lhs: JSONNullMessageGetHospitalCount, rhs: JSONNullMessageGetHospitalCount) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNullMessageGetHospitalCount.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


// MARK: - HospitalInformation
struct HospitalInformation: Decodable {
    let hospitalInformation: [HospitalInformationElement]
    let message: MessageHospitalInformation

    enum CodingKeys: String, CodingKey {
        case hospitalInformation = "Hospital_Information"
        case message
    }
}

// MARK: - HospitalInformationElement
struct HospitalInformationElement: Decodable {
    let hospName, hospAddress, hospPhoneNo, hospLevelOfCare: String
    let longitude, latitude: String

    enum CodingKeys: String, CodingKey {
        case hospName = "HOSP_NAME"
        case hospAddress = "HOSP_ADDRESS"
        case hospPhoneNo = "HOSP_PHONE_NO"
        case hospLevelOfCare = "HOSP_LEVEL_OF_CARE"
        case longitude = "LONGITUDE"
        case latitude = "LATITUDE"
    }
}

// MARK: - Message
struct MessageHospitalInformation: Decodable {
    let message: String
    let status: Bool
    let responseData: JSONNullHospitalInformation?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case responseData = "ResponseData"
    }
}

// MARK: - Encode/decode helpers

class JSONNullHospitalInformation: Codable, Hashable {

    public static func == (lhs: JSONNullHospitalInformation, rhs: JSONNullHospitalInformation) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNullHospitalInformation.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
