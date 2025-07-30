//
//  RecordListRepository.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

// TODO: check if protocol witness is really a best shot in here, since the strategy might change and it does not seem to
// be very type safe
// TODO: replace filter type with Configuration protocol to allow nice reusability for all types
struct RecordListRepository: Sendable {
    var saveRecord: @Sendable (_ record: ActivityRecord) async -> Result<Void, RecordListRepositoryError>
    var loadRecords: @Sendable (_ filter: FilterType) async -> Result<[ActivityRecord], RecordListRepositoryError>
    var deleteRecord: @Sendable (_ record: ActivityRecord) async -> Result<Void, RecordListRepositoryError>
}

enum RecordListRepositoryError: Error {
    case repositoryError
}
