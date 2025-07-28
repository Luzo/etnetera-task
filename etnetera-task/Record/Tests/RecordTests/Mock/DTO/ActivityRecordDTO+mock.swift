//
//  ActivityRecordDTO+mock.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Foundation

@testable import Record

extension ActivityRecordDTO {
    static func mock(
        id: String = UUID.with(intValue: 0).uuidString,
        name: String = "name",
        location: String = "location",
        duration: Double = 1
    ) -> ActivityRecordDTO {
        return ActivityRecordDTO(
            id: id,
            name: name,
            location: location,
            duration: duration
        )
    }
}
