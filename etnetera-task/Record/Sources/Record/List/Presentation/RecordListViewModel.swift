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
    let id: UUID
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
    var loadedRecords: [ActivityRecord] = []

    var records: [FormattedActivityRecord] = []
    var selectedFilter: FilterType = .all
}

extension RecordListViewModel {
    func onTask() async {
        await loadRecords()
    }

    func onRefresh() async {
        await loadRecords()
    }

    func filterChanged() async {
        setRecordsForFilters(filter: selectedFilter)
    }

    func onAddTapped() async {
        coordinator.navigate(to: .addRecord)
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
                id: $0.id,
                name: $0.name,
                location: $0.location,
                duration: durationFormatter.formattedDuration($0.duration),
                storageType: $0.storageType
            )
        }
    }

    private func loadRecords() async {
        // TODO: check connection for remote
        let result = await recordsRepository.loadRecords(selectedFilter)
        loadedRecords.removeAll {
            selectedFilter.acceptedStorageTypes.contains($0.storageType)
        }

        switch result {
        case let .success(records):
            loadedRecords.append(contentsOf: records)
        case .failure:
            // TODO: ???
            break
        }

        setRecordsForFilters(filter: selectedFilter)
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

// TODO: move to tests when implemented
extension ActivityRecord {
    static var mocks: [Self] {
        [
            .init(id: UUID(uuidString: "1bbb9689-d2e6-484b-9828-f43b5c523ff0")!, name: "Running", location: "Park", duration: 120, storageType: .local),
            .init(id: UUID(uuidString: "2bbb9689-d2e6-484b-9828-f43b5c523ff0")!, name: "Jumping", location: "Park", duration: 120, storageType: .local),
            .init(id: UUID(uuidString: "3bbb9689-d2e6-484b-9828-f43b5c523ff0")!, name: "Strength", location: "Park", duration: 120, storageType: .remote),
        ]
    }
}
