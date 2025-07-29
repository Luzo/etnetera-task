//
//  LocalRecordListRepository+live.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Factory
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
                return .success(())
            },
            loadRecords: { _ in
                let recordsResult = await onDeviceCache.loadRecords()
                if let error = recordsResult.failureOrNil {
                    return .failure(.repositoryError)
                }

                let converted = (recordsResult.successOrNil ?? []).map { converter.toDomain(.local, $0) }
                let successes = converted.compactMap(\.successOrNil)
                let errors = converted.compactMap(\.failureOrNil)

                if successes.isEmpty, let firstError = errors.first {
                    return .failure(.repositoryError)
                }

                return .success(successes)
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
