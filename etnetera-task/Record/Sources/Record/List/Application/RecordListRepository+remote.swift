//
//  RecordListRepository+remote.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

extension RecordListRepository {
    static func remote() -> Self {
        return .init(
            saveRecord: { record in
                fatalError("Not implemented")
            },
            loadRecords: { _ in
                fatalError("Not implemented")
            }
        )
    }
}

