// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let claimDetails = try? JSONDecoder().decode(ClaimDetails.self, from: jsonData)

import Foundation

// MARK: - ClaimDetails
struct ClaimDetails: Decodable {
    let loadDetailedClaimsValues: LoadDetailedClaimsValues
    let memberInformation: MemberInformation
    let claimPolicyInformation: ClaimPolicyInformation
    let claimHospitalInformation: ClaimHospitalInformation
    let claimIncidentInformation: ClaimIncidentInformation
    let claimAilmentInformation: ClaimAilmentInformation
    let claimProcessInformation: ClaimProcessInformation
    let claimChargesInformation: ClaimChargesInformation
    let claimPaymentInformation: ClaimPaymentInformation
    let claimFileDtInformation: ClaimFileDtInformation
    let claimCashlessInformation: ClaimCashlessInformation
    let message: MessageClaimDetails

    enum CodingKeys: String, CodingKey {
        case loadDetailedClaimsValues = "LoadDetailedClaimsValues"
        case memberInformation = "MEMBER_INFORMATION"
        case claimPolicyInformation = "CLAIM_POLICY_INFORMATION"
        case claimHospitalInformation = "CLAIM_HOSPITAL_INFORMATION"
        case claimIncidentInformation = "CLAIM_INCIDENT_INFORMATION"
        case claimAilmentInformation = "CLAIM_AILMENT_INFORMATION"
        case claimProcessInformation = "CLAIM_PROCESS_INFORMATION"
        case claimChargesInformation = "CLAIM_CHARGES_INFORMATION"
        case claimPaymentInformation = "CLAIM_PAYMENT_INFORMATION"
        case claimFileDtInformation = "CLAIM_FILE_DT_INFORMATION"
        case claimCashlessInformation = "CLAIM_CASHLESS_INFORMATION"
        case message
    }
}

// MARK: - ClaimAilmentInformation
struct ClaimAilmentInformation: Decodable {
    let ailment, finalDiagnosis, diseaseCategory, icdCode: String

    enum CodingKeys: String, CodingKey {
        case ailment = "AILMENT"
        case finalDiagnosis = "FINAL_DIAGNOSIS"
        case diseaseCategory = "DISEASE_CATEGORY"
        case icdCode = "ICD_CODE"
    }
}

// MARK: - ClaimCashlessInformation
struct ClaimCashlessInformation: Decodable {
    let cashlessStatus, cashlessRequestedOn, cashlessSentDate, cashlessAmount: String

    enum CodingKeys: String, CodingKey {
        case cashlessStatus = "CashlessStatus"
        case cashlessRequestedOn = "CashlessRequestedOn"
        case cashlessSentDate = "CashlessSentDate"
        case cashlessAmount = "CashlessAmount"
    }
}

// MARK: - ClaimChargesInformation
struct ClaimChargesInformation: Decodable {
    let deductionReasons, finalBillAmount, coPaymentDeduction, roomNursingCharges: String
    let surgeryCharges, consultantCharges, investigationCharges, miscellaneousCharges: String
    let nonPayableExpenses, medicineCharges: String

    enum CodingKeys: String, CodingKey {
        case deductionReasons = "DEDUCTION_REASONS"
        case finalBillAmount = "FINAL_BILL_AMOUNT"
        case coPaymentDeduction = "CO_PAYMENT_DEDUCTION"
        case roomNursingCharges = "ROOM_NURSING_CHARGES"
        case surgeryCharges = "SURGERY_CHARGES"
        case consultantCharges = "CONSULTANT_CHARGES"
        case investigationCharges = "INVESTIGATION_CHARGES"
        case miscellaneousCharges = "MISCELLANEOUS_CHARGES"
        case nonPayableExpenses = "NonPayableExpenses"
        case medicineCharges = "MedicineCharges"
    }
}

// MARK: - ClaimFileDtInformation
struct ClaimFileDtInformation: Decodable {
    let fileReceivedDate, deficiencies, firstDeficiencyLetterDate, secondDeficiencyLetterDate: String
    let deficiencyIntimationDate, deficienciesRetrievalDate: String

    enum CodingKeys: String, CodingKey {
        case fileReceivedDate = "FILE_RECEIVED_DATE"
        case deficiencies = "DEFICIENCIES"
        case firstDeficiencyLetterDate = "FIRST_DEFICIENCY_LETTER_DATE"
        case secondDeficiencyLetterDate = "SECOND_DEFICIENCY_LETTER_DATE"
        case deficiencyIntimationDate = "DEFICIENCY_INTIMATION_DATE"
        case deficienciesRetrievalDate = "DEFICIENCIES_RETRIEVAL_DATE"
    }
}

// MARK: - ClaimHospitalInformation
struct ClaimHospitalInformation: Decodable {
    let hospitalNo, hospitalName, isInNetwork, networkCity: String
    let networkState, levelOfCare, dateOfAdmission, dateOfDischarge: String
    let lengthOfStay: String

    enum CodingKeys: String, CodingKey {
        case hospitalNo = "HOSPITAL_NO"
        case hospitalName = "HOSPITAL_NAME"
        case isInNetwork = "IS_IN_NETWORK"
        case networkCity = "NETWORK_CITY"
        case networkState = "NetworkState"
        case levelOfCare = "LevelOfCare"
        case dateOfAdmission = "DateOfAdmission"
        case dateOfDischarge = "DateOfDischarge"
        case lengthOfStay = "LengthOfStay"
    }
}

// MARK: - ClaimIncidentInformation
struct ClaimIncidentInformation: Decodable {
    let claimNo, claimUniqueNo, claimExtension, claimPartialPaymentSequence: String
    let claimDate: String

    enum CodingKeys: String, CodingKey {
        case claimNo = "ClaimNo"
        case claimUniqueNo = "ClaimUniqueNo"
        case claimExtension = "ClaimExtension"
        case claimPartialPaymentSequence = "ClaimPartialPaymentSequence"
        case claimDate = "ClaimDate"
    }
}

// MARK: - ClaimPaymentInformation
struct ClaimPaymentInformation: Decodable {
    let dateOfSettlement, bankChequeNo, dateOfPaymentToMember, amountPaidToMember: String
    let chequeNoToMember, dateOfPaymentToHospital, amountPaidToHospital: String

    enum CodingKeys: String, CodingKey {
        case dateOfSettlement = "DATE_OF_SETTLEMENT"
        case bankChequeNo = "BANK_CHEQUE_NO"
        case dateOfPaymentToMember = "DATE_OF_PAYMENT_TO_MEMBER"
        case amountPaidToMember = "AMOUNT_PAID_TO_MEMBER"
        case chequeNoToMember = "CHEQUE_NO_TO_MEMBER"
        case dateOfPaymentToHospital = "DateOfPaymentToHospital"
        case amountPaidToHospital = "AmountPaidToHospital"
    }
}

// MARK: - ClaimPolicyInformation
struct ClaimPolicyInformation: Decodable {
    let claimSrNo: String

    enum CodingKeys: String, CodingKey {
        case claimSrNo = "CLAIM_SR_NO"
    }
}

// MARK: - ClaimProcessInformation
struct ClaimProcessInformation: Decodable {
    let tpaID: String?
    let reportedAmount, amount, paidAmount, rejectedCloseDate: String
    let typeOfClaim, outstandingClaimStatus, denialReasons, closeReasons: String
    let claimStatus, claimPaidDate, claimRejectedDate, claimClosedDate: String

    enum CodingKeys: String, CodingKey {
        case tpaID = "TPA_ID"
        case reportedAmount = "REPORTED_AMOUNT"
        case amount = "AMOUNT"
        case paidAmount = "PAID_AMOUNT"
        case rejectedCloseDate = "REJECTED_CLOSE_DATE"
        case typeOfClaim = "TypeOfClaim"
        case outstandingClaimStatus = "OUTSTANDING_CLAIM_STATUS"
        case denialReasons = "DENIAL_REASONS"
        case closeReasons = "CLOSE_REASONS"
        case claimStatus = "ClaimStatus"
        case claimPaidDate = "ClaimPaidDate"
        case claimRejectedDate = "ClaimRejectedDate"
        case claimClosedDate = "ClaimClosedDate"
    }
}

// MARK: - LoadDetailedClaimsValues
struct LoadDetailedClaimsValues: Decodable {
    let claimSrNo, fir, uniqueFir, groupCode: String
    let employeeNo, employeeSrNo: String

    enum CodingKeys: String, CodingKey {
        case claimSrNo = "CLAIM_SR_NO"
        case fir = "FIR"
        case uniqueFir = "UNIQUE_FIR"
        case groupCode = "GROUP_CODE"
        case employeeNo = "EMPLOYEE_NO"
        case employeeSrNo = "EMPLOYEE_SR_NO"
    }
}

// MARK: - MemberInformation
struct MemberInformation: Decodable {
    let beneficiaryName, employeeName, employeeNo, age: String
    let dateOfBirth, gender, grade, plantDept: String
    let city, sumInsured, tpaID, relation: String

    enum CodingKeys: String, CodingKey {
        case beneficiaryName = "BENEFICIARY_NAME"
        case employeeName = "EMPLOYEE_NAME"
        case employeeNo = "EMPLOYEE_NO"
        case age = "AGE"
        case dateOfBirth = "DATE_OF_BIRTH"
        case gender = "GENDER"
        case grade = "GRADE"
        case plantDept = "PLANT_DEPT"
        case city = "CITY"
        case sumInsured = "SUM_INSURED"
        case tpaID = "TPAId"
        case relation = "Relation"
    }
}

// MARK: - Message
struct MessageClaimDetails: Codable {
    let message: String
    let status: Bool
    let responseData: JSONNullClaimDetails?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case responseData = "ResponseData"
    }
}

// MARK: - Encode/decode helpers

class JSONNullClaimDetails: Codable, Hashable {

    public static func == (lhs: JSONNullClaimDetails, rhs: JSONNullClaimDetails) -> Bool {
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
