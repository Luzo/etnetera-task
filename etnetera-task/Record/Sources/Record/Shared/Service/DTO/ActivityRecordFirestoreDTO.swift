//
//  ActivityRecordFirestoreDTO.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import Factory

struct ActivityRecordFirestoreDTO: ActivityRecordDTO, Codable {
    let id: String
    let name: String
    let location: String
    let duration: Double
}

struct ActivityRecordFirestoreDTOConverter: Sendable {
    var fromDomain: @Sendable (SendableActivityRecordDTO) -> ActivityRecordFirestoreDTO
    var toDomain: @Sendable (ActivityRecordFirestoreDTO) -> SendableActivityRecordDTO
}

extension ActivityRecordFirestoreDTOConverter {
    static var live: ActivityRecordFirestoreDTOConverter {
        .init(
            fromDomain: {
                ActivityRecordFirestoreDTO(
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
    var activityRecordFirestoreConverter: Factory<ActivityRecordFirestoreDTOConverter> {
        Factory(self) { ActivityRecordFirestoreDTOConverter.live }
    }
}
