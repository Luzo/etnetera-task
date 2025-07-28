//
//  LocalRecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Factory

// TODO: add LocalRecordCache here to ease out on requests
extension RecordListRepository {
    static func onDevice(
        onDeviceCache: some OnDeviceRecordService,
    ) -> Self {
        return .init(
            saveRecord: { record in
                await onDeviceCache.saveRecord(record)
                return .success(())
            },
            loadRecords: { _ in
                let records = await onDeviceCache.loadRecords().get()
                return .success(records)
            }
        )
    }
}

extension Container {
    func onDeviceRecordListRepository(onDeviceCache: some OnDeviceRecordService) -> Factory<RecordListRepository> {
        Factory(self) { RecordListRepository.onDevice(
            onDeviceCache: onDeviceCache
        )}
    }
}
