//
//  RecordListRepository+localMock.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

@testable import Record

actor LocalRecordCacheMock: OnDeviceRecordService {
    var records: [SendableActivityRecordDTO] = []

    init(records: [SendableActivityRecordDTO] = []) {
        self.records = records
    }

    func loadRecords() async -> Result<[SendableActivityRecordDTO], OnDeviceRecordServiceError> {
        .success(records)
    }

    func saveRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, OnDeviceRecordServiceError> {
        records.append(record)
        return .success(())
    }

    func deleteRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, OnDeviceRecordServiceError> {
        records.removeAll(where: { $0.id == record.id })
        return .success(())
    }
}

