//
//  RecordListRepository.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

// TODO: check if protocol witness is really a best shot in here, since the strategy might change and it does not seem to
// be very type safe
// TODO: Might replace throw with Result for ErrorTypeSafety
struct RecordListRepository: Sendable {
    var cachedRecords: @Sendable () -> [ActivityRecord]
    var saveRecord: @Sendable (_ record: ActivityRecord) async throws -> Void
    var loadRecords: @Sendable (_ filter: FilterType) async throws -> [ActivityRecord]
}

enum RecordListRepositoryError: Error {
    case serverError
}
