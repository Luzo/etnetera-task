//
//  RecordListRepository+localMock.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

@testable import Record

actor LocalRecordCacheMock: OnDeviceRecordService {
    var records: [ActivityRecord] = []

    init(records: [ActivityRecord] = []) {
        self.records = records
    }

    func loadRecords() async -> Result<[ActivityRecord], Never> {
        .success(records)
    }

    func saveRecord(_ record: ActivityRecord) async -> Result<Void, Never> {
        records.append(record)
        return .success(())
    }
}

