//
//  LocalRecordCache.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

import Foundation
import Factory

actor LocalRecordCache: OnDeviceRecordService {
    var cache: [SendableActivityRecordDTO] = []

    init(cache: [SendableActivityRecordDTO] = []) {
        self.cache = cache
    }

    func loadRecords() async -> Result<[SendableActivityRecordDTO], OnDeviceRecordServiceError> {
        .success(cache)
    }

    func saveRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, OnDeviceRecordServiceError> {
        cache.append(record)
        return .success(())
    }

    func deleteRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, OnDeviceRecordServiceError> {
        cache.removeAll(where: { $0.id == record.id })
        return .success(())
    }
}

extension Container {
    func localRecordCache(cache: [SendableActivityRecordDTO]) -> Factory<some OnDeviceRecordService> {
        Factory(self) { LocalRecordCache(cache: cache) }
            .singleton
    }
}
