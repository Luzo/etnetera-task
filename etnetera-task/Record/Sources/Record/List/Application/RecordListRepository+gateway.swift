//
//  RecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Factory

extension RecordListRepository {
    static func gateway(
        localRepository: RecordListRepository,
        remoteRepository: RecordListRepository
    ) -> Self {
        return .init(
            saveRecord: { record in
                switch record.storageType {
                case .local:
                    return await localRepository.saveRecord(record)
                case .remote:
                    return await remoteRepository.saveRecord(record)
                }
            },
            loadRecords: { filterType in
                switch filterType {
                case .local:
                    return await localRepository.loadRecords(filterType)
                case .remote:
                    return await remoteRepository.loadRecords(filterType)
                case .all:
                    async let localResult = localRepository.loadRecords(.local)
                    async let remoteResult = remoteRepository.loadRecords(.remote)

                    let results = await (localResult, remoteResult)

                    // TODO: this will need some extra look for better error handling
                    switch results {
                    case (.success(let localRecords), .success(let remoteRecords)):
                        return .success(localRecords + remoteRecords)
                    case (.failure, .success(let remoteRecords)):
                        return .success(remoteRecords)
                    case (.success(let localRecords), .failure):
                        return .success(localRecords)
                    case (.failure, _):
                        return .failure(.serverError)
                    case (_, .failure):
                        return .failure(.serverError)
                    }
                }
            }
        )
    }
}

extension Container {
    var gatewayRecordListRepository: Factory<RecordListRepository> {
        Factory(self) { RecordListRepository.gateway(
            localRepository: self.onDeviceRecordListRepository(
                // TODO: replace with actual on device cache instead
                onDeviceCache: self.localRecordCache(cache: ActivityRecord.mocks)()
            )(),
            remoteRepository: self.remoteRecordListRepository(
                recordService: self.firestoreRecordService()
            )()
        )}
    }
}
