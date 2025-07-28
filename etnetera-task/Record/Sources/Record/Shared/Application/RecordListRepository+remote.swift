//
//  RecordListRepository+remote.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Factory

// TODO: add LocalRecordCache here to ease out on requests
extension RecordListRepository {
    static func remote(
        recordService: some RemoteRecordService
    ) -> Self {
        return .init(
            saveRecord: { record in
                await recordService.saveRecord(record)
                    .mapError(\.asRecordListRepositoryError)

            },
            loadRecords: { _ in
                await recordService.loadRecords()
                    .mapError(\.asRecordListRepositoryError)
            }
        )
    }
}

private extension RemoteRecordServiceError {
    var asRecordListRepositoryError: RecordListRepositoryError {
        switch self {
        case .serverError:
            return .serverError
        }
    }
}

extension Container {
    func remoteRecordListRepository(recordService: some RemoteRecordService) -> Factory<RecordListRepository> {
        Factory(self) { RecordListRepository.remote(
            recordService: recordService
        )}
    }
}
