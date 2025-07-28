//
//  FirestoreRecordServiceTests.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

import Testing

@testable import Record

struct FirestoreRecordServiceTests {
    @Test
    func sut_should_return_failure_on_load() async {
        let sut = FirestoreRecordService()
        let result = await sut.loadRecords()
        #expect(result.failureOrNil == .serverError)
    }

    @Test
    func sut_should_return_failure_on_save() async {
        let sut = FirestoreRecordService()
        let result = await sut.saveRecord(.mock())
        #expect(result.failureOrNil == .serverError)
    }
}
