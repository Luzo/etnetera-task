//
//  LocalRecordCacheTests.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

import Testing

@testable import Record

struct LocalRecordCacheTests {
    @Test
    func sut_should_load_records() async {
        let expectedRecords: [SendableActivityRecordDTO] = [.mock()]
        let sut = LocalRecordCache(cache: expectedRecords)

        let result = await sut.loadRecords()
        #expect(result.successOrNil == expectedRecords)
    }

    @Test
    func sut_should_save_record() async {
        let expectedRecord: SendableActivityRecordDTO = .mock()
        let sut = LocalRecordCache()

        let result = await sut.saveRecord(expectedRecord)
        #expect(result.successOrNil != nil)
        #expect(await sut.cache == [expectedRecord])
    }
}
