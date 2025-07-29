//
//  ActivityRecordDTO.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Factory
import Foundation

protocol ActivityRecordDTO: Equatable {
    var id: String { get }
    var name: String { get }
    var location: String { get }
    var duration: Double { get }

    init(id: String, name: String, location: String, duration: Double)
}

struct SendableActivityRecordDTO: ActivityRecordDTO, Sendable {
    let id: String
    let name: String
    let location: String
    let duration: Double
}

enum ActivityRecordConverterError: Error {
    case conversionError
}

struct ActivityRecordConverter: Sendable {
    var fromDomain: @Sendable (ActivityRecord) -> SendableActivityRecordDTO
    var toDomain: @Sendable (StorageType, SendableActivityRecordDTO) -> Result<ActivityRecord, ActivityRecordConverterError>
}

extension ActivityRecordConverter {
    static var live: ActivityRecordConverter {
        .init(
            fromDomain: {
                SendableActivityRecordDTO(
                    id: $0.id.uuidString,
                    name: $0.name,
                    location: $0.location,
                    duration: $0.duration
                )
            },
            toDomain: { storageType, record in
                guard let uuid = UUID(uuidString: record.id) else {
                    return .failure(.conversionError)
                }

                return .success(ActivityRecord(
                    id: uuid,
                    name: record.name,
                    location: record.location,
                    duration: record.duration,
                    storageType: storageType
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
