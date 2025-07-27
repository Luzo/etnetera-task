//
//  LocalRecordCache.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

actor LocalRecordCache: OnDeviceCache {
    private var records: [ActivityRecord] = []

    func getRecords() -> [ActivityRecord] {
        records
    }

    func addRecord(_ newRecord: ActivityRecord) {
        records.append(newRecord)
    }
}
