//
//  UserSwiftDataDTO.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import SwiftData

@Model
final class UserSwiftDataDTO {
    @Attribute(.unique) var id: String

    @Relationship(deleteRule: .cascade, inverse: \ActivityRecordSwiftDataDTO.user)
    var records: [ActivityRecordSwiftDataDTO] = []

    init(id: String) {
        self.id = id
    }
}
