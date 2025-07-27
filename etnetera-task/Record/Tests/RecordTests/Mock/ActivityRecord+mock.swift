//
//  ActivityRecord+mock.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Foundation
@testable import Record

extension ActivityRecord {
    static func mock(
        uuid: UUID = .with(intValue: 0),
        name: String = "name",
        location: String = "location",
        duration: TimeInterval = 1,
        storageType: StorageType = .local,
    ) -> ActivityRecord {
        return ActivityRecord(
            id: uuid,
            name: name,
            location: location,
            duration: duration,
            storageType: storageType
        )
    }
}
