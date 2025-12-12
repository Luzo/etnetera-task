//
//  RecordListRepositoryRemoteTests.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

import FactoryKit
import FactoryTesting
import Testing

@testable import Record

@Suite(.container)
struct RecordListRepositoryRemoteTests {
    @Test
    func sut_should_return_failure_on_load() async {
        let sut = RecordListRepository.remote(recordService: RemoteRecordServiceStub(), converter: .live)
        let result = await sut.loadRecords(.remote)
        #expect(result.failureOrNil == .repositoryError)
    }

    @Test
    func sut_should_return_failure_on_save() async {
        let sut = RecordListRepository.remote(recordService: RemoteRecordServiceStub(), converter: .live)
        let result = await sut.saveRecord(.mock())
        #expect(result.failureOrNil == .repositoryError)
    }

    @Test
    func sut_should_return_success_on_load() async {
        let sut = RecordListRepository.remote(
            recordService: RemoteRecordServiceStub(
                loadRecords: .success([SendableActivityRecordDTO.mock()])
            ),
            converter: .live
        )
        let result = await sut.loadRecords(.remote)
        #expect(result.successOrNil == [ActivityRecord.mock(storageType: .remote)])
    }

    @Test
    func sut_should_return_success_on_save() async {
        let sut = RecordListRepository.remote(
            recordService: RemoteRecordServiceStub(saveRecords: .success(())),
            converter: .live
        )
        let result = await sut.saveRecord(.mock())
        #expect(result.successOrNil != nil)
    }
}
