//
//  LocalRecordCache.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

actor LocalRecordCache: OnDeviceRecordService {
    var cache: [ActivityRecord] = []

    init(cache: [ActivityRecord] = []) {
        self.cache = cache
    }

    func loadRecords() async -> Result<[ActivityRecord], Never> {
        .success(cache)
    }

    func saveRecord(_ record: ActivityRecord) async -> Result<Void, Never> {
        cache.append(record)
        return .success(())
    }
}
