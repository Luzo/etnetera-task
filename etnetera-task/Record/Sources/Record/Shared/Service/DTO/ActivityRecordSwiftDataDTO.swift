//
//  ActivityRecordSwiftDataDTO.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import Factory
import Foundation
import SwiftData

@Model
final class ActivityRecordSwiftDataDTO: ActivityRecordDTO {
    @Attribute(.unique) var id: String
    var name: String
    var location: String
    var duration: Double

    @Relationship var user: UserSwiftDataDTO?

    init(id: String, name: String, location: String, duration: Double) {
        self.id = id
        self.name = name
        self.location = location
        self.duration = duration
    }
}


struct ActivityRecordSwiftDataDTOConverter: Sendable {
    var fromDomain: @Sendable (SendableActivityRecordDTO) -> ActivityRecordSwiftDataDTO
    var toDomain: @Sendable (ActivityRecordSwiftDataDTO) -> SendableActivityRecordDTO
}

extension ActivityRecordSwiftDataDTOConverter {
    static var live: ActivityRecordSwiftDataDTOConverter {
        .init(
            fromDomain: {
                ActivityRecordSwiftDataDTO(
                    id: $0.id,
                    name: $0.name,
                    location: $0.location,
                    duration: $0.duration
                )
            },
            toDomain: {
                SendableActivityRecordDTO(
                    id: $0.id,
                    name: $0.name,
                    location: $0.location,
                    duration: $0.duration
                )
            }
        )
    }
}

extension Container {
    var activityRecordSwiftDataConverter: Factory<ActivityRecordSwiftDataDTOConverter> {
        Factory(self) { ActivityRecordSwiftDataDTOConverter.live }
    }
}
