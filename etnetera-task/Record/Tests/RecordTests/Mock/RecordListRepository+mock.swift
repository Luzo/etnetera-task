//
//  RecordListRepository+mock.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

@testable import Record

extension RecordListRepository {
    static func mock(
        cachedRecords: @Sendable @escaping () -> [ActivityRecord] = { [] },
        saveRecord: @Sendable @escaping (_ record: ActivityRecord) async throws -> Void = { _ in
            throw MockError.unexpectedCall
        },
        loadRecords: @Sendable @escaping (_ filter: FilterType) async throws -> [ActivityRecord] = { _ in
            throw MockError.unexpectedCall
        }
    ) -> Self {
        .init(cachedRecords: cachedRecords, saveRecord: saveRecord, loadRecords: loadRecords)
    }
}
