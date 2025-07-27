//
//  LocalRecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

// TODO: add LocalRecordCache here to ease out on requests
extension RecordListRepository {
    static func onDevice(
        // TODO: replace with actual on device cache instead
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

