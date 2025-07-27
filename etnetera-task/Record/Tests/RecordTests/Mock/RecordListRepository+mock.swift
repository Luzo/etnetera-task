//
//  RecordListRepository+mock.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

@testable import Record

extension RecordListRepository {
    static func mock(
        saveRecord: @Sendable @escaping (
            _ record: ActivityRecord
        ) async -> Result<Void, RecordListRepositoryError> = { _ in
            .failure(.serverError)
        },
        loadRecords: @Sendable @escaping (
            _ filter: FilterType
        ) async -> Result<[ActivityRecord], RecordListRepositoryError> = { _ in
            .failure(.serverError)
        }
    ) -> Self {
        .init(saveRecord: saveRecord, loadRecords: loadRecords)
    }
}
