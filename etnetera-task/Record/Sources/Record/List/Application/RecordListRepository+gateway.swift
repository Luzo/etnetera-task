//
//  RecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

extension RecordListRepository {
    static func gateway(
        localRepository: RecordListRepository,
        remoteRepository: RecordListRepository
    ) -> Self {
        return .init(
            cachedRecords: {
                localRepository.cachedRecords() + remoteRepository.cachedRecords()
            },
            saveRecord: { record in
                switch record.storageType {
                case .local:
                    return try await localRepository.saveRecord(record)
                case .remote:
                    return try await remoteRepository.saveRecord(record)
                }
            },
            loadRecords: { filterType in
                switch filterType {
                case .local:
                    return try await localRepository.loadRecords(filterType)
                case .remote:
                    return try await remoteRepository.loadRecords(filterType)
                case .all:
                    async let local = localRepository.loadRecords(.local)
                    async let remote = remoteRepository.loadRecords(.remote)
                    return try await local + remote
                }
            }
        )
    }
}
