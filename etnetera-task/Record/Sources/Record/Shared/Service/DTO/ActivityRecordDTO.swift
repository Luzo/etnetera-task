//
//  ActivityRecordDTO.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Factory
import Foundation

struct ActivityRecordDTO: Codable, Equatable {
    let id: String
    let name: String
    let location: String
    let duration: Double
}

enum ActivityRecordConverterError: Error {
    case conversionError
}

struct ActivityRecordConverter: Sendable {
    var fromDomain: @Sendable (ActivityRecord) -> ActivityRecordDTO
    var toDomain: @Sendable (ActivityRecordDTO) -> Result<ActivityRecord, ActivityRecordConverterError>
}

extension ActivityRecordConverter {
    static var live: ActivityRecordConverter {
        .init(
            fromDomain: {
                ActivityRecordDTO(
                    id: $0.id.uuidString,
                    name: $0.name,
                    location: $0.location,
                    duration: $0.duration
                )
            },
            toDomain: {
                guard let uuid = UUID(uuidString: $0.id) else {
                    return .failure(.conversionError)
                }

                return .success(ActivityRecord(
                    id: uuid,
                    name: $0.name,
                    location: $0.location,
                    duration: $0.duration,
                    storageType: .remote
                ))
            }
        )
    }
}

extension Container {
    var activityRecordConverter: Factory<ActivityRecordConverter> {
        Factory(self) { ActivityRecordConverter.live }
    }
}
