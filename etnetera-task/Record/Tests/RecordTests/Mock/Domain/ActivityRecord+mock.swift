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

extension ActivityRecord {
    static var mocks: [Self] {
        [
            .init(id: UUID(uuidString: "1bbb9689-d2e6-484b-9828-f43b5c523ff0")!, name: "Running", location: "Park", duration: 120, storageType: .local),
            .init(id: UUID(uuidString: "2bbb9689-d2e6-484b-9828-f43b5c523ff0")!, name: "Jumping", location: "Park", duration: 120, storageType: .local),
            .init(id: UUID(uuidString: "3bbb9689-d2e6-484b-9828-f43b5c523ff0")!, name: "Strength", location: "Park", duration: 120, storageType: .remote),
        ]
    }
}
