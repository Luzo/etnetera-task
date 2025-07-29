//
//  RecordListRepository+localTests.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Testing

@testable import Record

struct RecordListRepositoryLocalTests {
    @Test
    func sut_should_save_record() async throws {
        let mock: ActivityRecord = .mock()
        let expectedResult: SendableActivityRecordDTO = .mock()
        let cacheSpy = LocalRecordCacheMock()
        let sut = RecordListRepository.onDevice(onDeviceCache: cacheSpy, converter: .live)

        try await sut.saveRecord(mock).get()
        await #expect(cacheSpy.records == [expectedResult])
    }

    @Test
    func sut_should_load_records_for_type() async throws {
        let expectedResult: [ActivityRecord] = [.mock()]
        let mockedResult: [SendableActivityRecordDTO] = [.mock()]
        let cacheMock = LocalRecordCacheMock(records: mockedResult)
        let sut = RecordListRepository.onDevice(onDeviceCache: cacheMock, converter: .live)

        let result = try await sut.loadRecords(.local).get()
        #expect(result == expectedResult)
    }
}
