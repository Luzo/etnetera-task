//
//  RecordListViewModel.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Foundation
import Observation

// TODO: Do localizations elsewhere
enum FilterType: String, CaseIterable {
    case all = "All"
    case local = "Local"
    case remote = "Remote"
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
    @ObservationIgnored var loadedRecords: [ActivityRecord] = []
    var records: [FormattedActivityRecord] = []
    var selectedFilter: FilterType = .all


    func onTask() async {
        Task {
            await loadRecords()
        }
    }

    func onRefresh() async {
        Task {
            await loadRecords()
        }
    }

    func filterChanged() async {
        setRecordsForFilters(filter: selectedFilter)
    }
}

private extension RecordListViewModel {

    private func setRecordsForFilters(filter: FilterType) {
        // TODO: Add as a dependency instead
        let durationFormatter = ActivityDurationFormatter()

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
        // TODO: check connection + do some optimizations
        // TODO: load this through some gateway LOCAL + DB in some extra task
        loadedRecords = ActivityRecord.mocks
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
