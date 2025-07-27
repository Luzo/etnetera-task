//
//  LocalRecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

extension RecordListRepository {
    static func onDevice(
        // TODO: replace with actual on device cache instead
        onDeviceCache: OnDeviceCache,
    ) -> Self {
        return .init(
            saveRecord: { record in
                await onDeviceCache.addRecord(record)
                return .success(())
            },
            loadRecords: { _ in
                let records = await onDeviceCache.getRecords()
                return .success(records)
            }
        )
    }
}

