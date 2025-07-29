//
//  RecordListRepository+remote.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Factory
import Utils

// TODO: add LocalRecordCache here to ease out on requests
extension RecordListRepository {
    static func remote(
        recordService: some RemoteRecordService,
        converter: ActivityRecordConverter
    ) -> Self {
        return .init(
            saveRecord: { record in
                let recordToSave = converter.fromDomain(record)

                return await recordService.saveRecord(recordToSave)
                    .mapError(\.asRecordListRepositoryError)

            },
            loadRecords: { _ in
                let recordsResult = await recordService.loadRecords()

                if let error = recordsResult.failureOrNil {
                    return .failure(error.asRecordListRepositoryError)
                }

                let converted = (recordsResult.successOrNil ?? []).map { converter.toDomain(.remote, $0) }
                let successes = converted.compactMap(\.successOrNil)
                let errors = converted.compactMap(\.failureOrNil)

                if successes.isEmpty, let firstError = errors.first {
                    return .failure(firstError.asRecordListRepositoryError)
                }

                return .success(successes)
            }
        )
    }
}

private extension ActivityRecordConverterError {
    var asRemoteRecordServiceError: RemoteRecordServiceError {
        switch self {
        case .conversionError:
            return .serverError
        }
    }

    var asRecordListRepositoryError: RecordListRepositoryError {
        asRemoteRecordServiceError.asRecordListRepositoryError
    }
}

private extension RemoteRecordServiceError {
    var asRecordListRepositoryError: RecordListRepositoryError {
        switch self {
        case .serverError:
            return .repositoryError
        }
    }
}

extension Container {
    func remoteRecordListRepository(recordService: some RemoteRecordService) -> Factory<RecordListRepository> {
        Factory(self) { RecordListRepository.remote(
            recordService: recordService,
            converter: self.activityRecordConverter()
        )}
    }
}
