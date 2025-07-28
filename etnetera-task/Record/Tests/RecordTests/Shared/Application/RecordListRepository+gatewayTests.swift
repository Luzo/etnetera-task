//
//  RecordListRepository+gatewayTests.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Testing

@testable import Record

struct RecordListRepositoryGatewayTests {
    @Test(
        arguments: [
            (ActivityRecord.mock(storageType: .local), StorageType.local),
            (ActivityRecord.mock(storageType: .remote), StorageType.remote),
        ]
    )
    func sut_should_save_record_to_correct_repository(
        mockedRecord: ActivityRecord,
        storageType: StorageType
    ) async throws {
        try await confirmation { confirmation in
            let mockedRepository: RecordListRepository = .mock(saveRecord: { record in
                #expect(mockedRecord == record)

                confirmation.confirm()
                return .success(())
            })

            let sut = RecordListRepository.gateway(
                localRepository: storageType == .local ? mockedRepository : .mock(),
                remoteRepository: storageType == .remote ? mockedRepository : .mock(),
            )
            try await sut.saveRecord(mockedRecord).get()
        }
    }

    @Test
    func sut_should_load_records_for_filter_type() async throws {
        let mockedRecord = ActivityRecord.mock()
        let filterType = FilterType.local

        let mockedRepository: RecordListRepository = .mock(loadRecords: { filter in
            .success([mockedRecord])
        })

        let sut = RecordListRepository.gateway(
            localRepository: filterType == .local ? mockedRepository : .mock(),
            remoteRepository: filterType == .remote ? mockedRepository : .mock(),
        )
        let records = try await sut.loadRecords(filterType).get()
        #expect(records == [mockedRecord])
    }
}
