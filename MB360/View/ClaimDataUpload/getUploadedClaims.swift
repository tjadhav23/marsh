// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getUploadedClaims = try? JSONDecoder().decode(GetUploadedClaims.self, from: jsonData)

import Foundation

// MARK: - GetUploadedClaims
struct GetUploadedClaims: Codable {
    let id: String
    let iTotalRecords, iTotalDisplayRecords: Int
    let aaData: [AaDatum]

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case iTotalRecords, iTotalDisplayRecords, aaData
    }
}

// MARK: - AaDatum
struct AaDatum: Codable {
    let id, clmDocsUploadReqNo, clmDocsUploadReqSrNo, clmDocsUloadedOn: String
    let lastModifiedBy, typeOfClaim, claimIntimated, claimIntimatedDest: String
    let clmIntSrNo, claimIntimationNo, personSrNo, personName: String
    let files, cellphoneNumber, dateOfBirth, age: String
    let eMailID, status, gender, relationid: String
    let uploadDocument, mandatoryDoc, statusdate: String

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case clmDocsUploadReqNo = "CLM_DOCS_UPLOAD_REQ_NO"
        case clmDocsUploadReqSrNo = "CLM_DOCS_UPLOAD_REQ_SR_NO"
        case clmDocsUloadedOn = "CLM_DOCS_ULOADED_ON"
        case lastModifiedBy = "LAST_MODIFIED_BY"
        case typeOfClaim = "TYPE_OF_CLAIM"
        case claimIntimated = "CLAIM_INTIMATED"
        case claimIntimatedDest = "CLAIM_INTIMATED_DEST"
        case clmIntSrNo = "CLM_INT_SR_NO"
        case claimIntimationNo = "CLAIM_INTIMATION_NO"
        case personSrNo = "PERSON_SR_NO"
        case personName = "PERSON_NAME"
        case files = "FILES"
        case cellphoneNumber = "CELLPHONE_NUMBER"
        case dateOfBirth = "DATE_OF_BIRTH"
        case age = "AGE"
        case eMailID = "E_MAIL_ID"
        case status = "STATUS"
        case gender = "GENDER"
        case relationid = "RELATIONID"
        case uploadDocument = "UPLOAD_DOCUMENT"
        case mandatoryDoc = "MANDATORY_DOC"
        case statusdate = "STATUSDATE"
    }
}
