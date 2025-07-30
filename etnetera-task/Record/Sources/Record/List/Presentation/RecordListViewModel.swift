//
//  RecordListViewModel.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Factory
import Foundation
import Observation

enum FilterType: CaseIterable {
    case all
    case local
    case remote
}

struct FormattedActivityRecord: Identifiable, Equatable {
    let id: String
    let name: String
    let location: String
    let duration: String
    let storageType: StorageType
}

@Observable
@MainActor
class RecordListViewModel {
    @ObservationIgnored
    @Injected(\.gatewayRecordListRepository) private var recordsRepository
    @ObservationIgnored
    @Injected(\.activityDurationFormatter) private var durationFormatter
    @ObservationIgnored
    @Injected(\.recordCoordinator) private var coordinator
    @ObservationIgnored
    @Injected(\.clock) private var clock

    @ObservationIgnored
    var loadedRecords: [ActivityRecord] = []

    @ObservationIgnored
    var loadedTypes: [StorageType] = []

    var records: [FormattedActivityRecord] = []
    var selectedFilter: FilterType = .all
    var isLoading: Bool = false
    var errorMessage: String?
}

extension RecordListViewModel {
    func onTask() async {
        loadedTypes = []
        await loadRecords()
    }

    func onRefresh() async {
        await loadRecords()
    }

    func filterChanged() async {
        setRecordsForFilters(filter: selectedFilter)
        if !selectedFilter.acceptedStorageTypes.allSatisfy(loadedTypes.contains) {
            await onRefresh()
        }
    }

    func onAddTapped() async {
        coordinator.navigate(to: .addRecord)
    }

    func onDeleteTapped(recordID: FormattedActivityRecord.ID) async {
        guard let recordToDelete = loadedRecords.first(where: { $0.id.uuidString == recordID}) else {
            return
        }

        switch await recordsRepository.deleteRecord(recordToDelete) {
        case .success:
            break
        case .failure:
            await onRefresh()
        }
    }
}

private extension RecordListViewModel {

    private func setRecordsForFilters(filter: FilterType) {
        records = loadedRecords
            .filter {
                filter.acceptedStorageTypes.contains($0.storageType)
            }
            .map {
            .init(
                id: $0.id.uuidString,
                name: $0.name,
                location: $0.location,
                duration: durationFormatter.formattedDuration($0.duration),
                storageType: $0.storageType
            )
        }
    }

    private func loadRecords() async {
        isLoading = true

        // TODO: check connection for remote
        let result = await recordsRepository.loadRecords(selectedFilter)
        try? await clock.sleep(for: .seconds(0.3))

        switch result {
        case let .success(records):
            loadedRecords.removeAll {
                selectedFilter.acceptedStorageTypes.contains($0.storageType)
            }
            loadedRecords.append(contentsOf: records)
            loadedTypes.append(contentsOf: selectedFilter.acceptedStorageTypes)
        case .failure:
            showDisappearingError(withMessage: LocalizationKeys.RecordList.error)
        }

        setRecordsForFilters(filter: selectedFilter)
        isLoading = false
    }

    private func showDisappearingError(withMessage message: String) {
        Task {
            errorMessage = message
            try? await clock.sleep(for: .seconds(2))
            errorMessage = nil
        }
    }
}

private extension FilterType {
    var acceptedStorageTypes: [StorageType] {
        switch self {
        case .all:
            return [.local, .remote]
        case .local:
            return [.local]
        case .remote:
            return [.remote]
        }
    }
}

extension Container {
    var recordListViewModel: Factory<RecordListViewModel> {
        Factory(self) { @MainActor in
            RecordListViewModel()
        }
        .unique
    }
}
