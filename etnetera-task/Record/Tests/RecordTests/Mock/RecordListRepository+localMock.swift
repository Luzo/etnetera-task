//
//  RecordListRepository+localMock.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

@testable import Record

actor LocalRecordCacheMock: OnDeviceCache {
    var records: [ActivityRecord] = []

    init(records: [ActivityRecord] = []) {
        self.records = records
    }

    func getRecords() -> [ActivityRecord] {
        records
    }

    func addRecord(_ newRecord: ActivityRecord) {
        records.append(newRecord)
    }
}

