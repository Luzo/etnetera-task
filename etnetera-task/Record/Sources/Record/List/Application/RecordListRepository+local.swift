//
//  LocalRecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

extension RecordListRepository {
    static func local() -> Self {
        return .init(
            cachedRecords: {
                fatalError("Not implemented")
            },
            saveRecord: { record in
                fatalError("Not implemented")

            },
            loadRecords: { _ in
                fatalError("Not implemented")
            }
        )
    }
}

