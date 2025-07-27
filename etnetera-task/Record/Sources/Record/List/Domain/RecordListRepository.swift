//
//  RecordListRepository.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

// TODO: check if protocol witness is really a best shot in here, since the strategy might change and it does not seem to
// be very type safe
struct RecordListRepository: Sendable {
    var saveRecord: @Sendable (_ record: ActivityRecord) async -> Result<Void, RecordListRepositoryError>
    var loadRecords: @Sendable (_ filter: FilterType) async -> Result<[ActivityRecord], RecordListRepositoryError>
}

enum RecordListRepositoryError: Error {
    case serverError
}
