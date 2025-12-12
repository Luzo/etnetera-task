//
//  LocalRecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import FactoryKit
import Utils

// TODO: add LocalRecordCache here to ease out on requests
extension RecordListRepository {
    static func onDevice(
        onDeviceCache: some OnDeviceRecordService,
        converter: ActivityRecordConverter
    ) -> Self {
        return .init(
            saveRecord: { record in
                await onDeviceCache.saveRecord(converter.fromDomain(record))
                    .mapError(\.asRecordListRepositoryError)
            },
            loadRecords: { _ in
                let recordsResult = await onDeviceCache.loadRecords()
                if let _ = recordsResult.failureOrNil {
                    return .failure(.repositoryError)
                }

                let converted = (recordsResult.successOrNil ?? []).map { converter.toDomain(.local, $0) }
                let successes = converted.compactMap(\.successOrNil)
                let errors = converted.compactMap(\.failureOrNil)

                if successes.isEmpty, let _ = errors.first {
                    return .failure(.repositoryError)
                }

                return .success(successes)
            },
            deleteRecord: { record in
                await onDeviceCache.deleteRecord(converter.fromDomain(record))
                    .mapError(\.asRecordListRepositoryError)
            }
        )
    }
}

extension Container {
    func onDeviceRecordListRepository(onDeviceCache: some OnDeviceRecordService) -> Factory<RecordListRepository> {
        Factory(self) { RecordListRepository.onDevice(
            onDeviceCache: onDeviceCache,
            converter: self.activityRecordConverter()
        )}
    }
}

private extension OnDeviceRecordServiceError {
    var asRecordListRepositoryError: RecordListRepositoryError {
        switch self {
        case .serviceError:
            return .repositoryError
        }
    }
}
