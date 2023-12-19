// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getRelationGroup = try? newJSONDecoder().decode(GetRelationGroup.self, from: jsonData)

import Foundation

// MARK: - GetRelationGroup
struct GetRelationGroup: Codable {
    let relations: [Relation]
}

// MARK: - Relation
struct Relation: Codable {
    let relationName: String
    let maxCount: Int
    let relationID, group: String
    let maxAge, minAge: Int

    enum CodingKeys: String, CodingKey {
        case relationName = "relation_name"
        case maxCount = "max_count"
        case relationID = "RelationID"
        case group
        case maxAge = "max_age"
        case minAge = "min_age"
    }
}
