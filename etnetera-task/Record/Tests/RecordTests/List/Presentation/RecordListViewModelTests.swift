//
//  RecordListViewModelTests.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Foundation
import Testing

@testable import Record

struct RecordListViewModelTests {
    @Test
    func sut_should_load_records_on_refresh() async throws {
        let sut = await RecordListViewModel()
        await sut._setMockReturningRepository(ActivityRecord.mocks)

        await #expect(sut.loadedRecords.isEmpty)

        await sut.onRefresh()
        await #expect(sut.loadedRecords == ActivityRecord.mocks)
    }

    @Test
    func sut_should_load_records_on_task() async throws {
        let sut = await RecordListViewModel()
        await sut._setMockReturningRepository(ActivityRecord.mocks)

        await #expect(sut.loadedRecords.isEmpty)

        await sut.onTask()
        await #expect(sut.loadedRecords == ActivityRecord.mocks)
    }

    @Test(
        .serialized,
        arguments: [
            (
                FilterType.all,
                [
                    FormattedActivityRecord(
                        id: .with(intValue: 1),
                        name: "1",
                        location: "1l",
                        duration: "0:01",
                        storageType: .local
                    ),
                    FormattedActivityRecord(
                        id: .with(intValue: 2),
                        name: "2",
                        location: "2l",
                        duration: "0:02",
                        storageType: .remote
                    ),
                ]
            ),
            (
                FilterType.local,
                [
                    FormattedActivityRecord(
                        id: .with(intValue: 1),
                        name: "1",
                        location: "1l",
                        duration: "0:01",
                        storageType: .local
                    ),
                ]
            ),
            (
                FilterType.remote,
                [
                    FormattedActivityRecord(
                        id: .with(intValue: 2),
                        name: "2",
                        location: "2l",
                        duration: "0:02",
                        storageType: .remote
                    ),
                ]
            )
        ]
    )
    func sut_should_filter_records_on_filter_changed(
        selectedFilter: FilterType,
        expectedFormattedModels: [FormattedActivityRecord]
    ) async throws {
        let sut = await RecordListViewModel()
        await sut._setFilter(selectedFilter)

        await #expect(sut.loadedRecords.isEmpty)
        await #expect(sut.records.isEmpty)

        let activityRecords: [ActivityRecord] = [
            .init(id: .with(intValue: 1), name: "1", location: "1l", duration: 1, storageType: .local),
            .init(id: .with(intValue: 2), name: "2", location: "2l", duration: 2, storageType: .remote),
        ]
        await sut._setLoadedRecords(activityRecords)
        await #expect(sut.loadedRecords == activityRecords)

        await sut.filterChanged()
        await #expect(sut.records == expectedFormattedModels)

    }
}

private extension RecordListViewModel {
    func _setFilter(_ filter: FilterType) async {
        selectedFilter = filter
    }

    func _setLoadedRecords(_ records: [ActivityRecord]) async {
        loadedRecords = records
    }

    func _setMockReturningRepository(_ records: [ActivityRecord]) async {
        recordsRepository = .mock(
            loadRecords: { _ in
                return .success(records)
            }
        )
    }
}
