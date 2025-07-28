//
//  RecordListViewModelTests.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Factory
import FactoryTesting
import Foundation
import Testing

@testable import Record

@Suite(.container)
struct RecordListViewModelTests {
    @Test
    @MainActor
    func sut_should_load_records_on_refresh() async throws {
        let expectedRecords = ActivityRecord.mocks
        Container.shared.gatewayRecordListRepository.register {
            .mock(loadRecords: { _ in return .success(expectedRecords) } )
        }
        let sut = RecordListViewModel()

        #expect(sut.loadedRecords.isEmpty)

        await sut.onRefresh()
        #expect(sut.loadedRecords == expectedRecords)
    }

    @Test
    @MainActor
    func sut_should_load_records_on_task() async throws {
        let expectedRecords = ActivityRecord.mocks
        Container.shared.gatewayRecordListRepository.register {
            .mock(loadRecords: { _ in return .success(expectedRecords) } )
        }
        let sut = RecordListViewModel()

        #expect(sut.loadedRecords.isEmpty)

        await sut.onTask()
        #expect(sut.loadedRecords == ActivityRecord.mocks)
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
    @MainActor
    func sut_should_filter_records_on_filter_changed(
        selectedFilter: FilterType,
        expectedFormattedModels: [FormattedActivityRecord]
    ) async throws {
        let sut = RecordListViewModel()
        await sut._setFilter(selectedFilter)

        #expect(sut.loadedRecords.isEmpty)
        #expect(sut.records.isEmpty)

        let activityRecords: [ActivityRecord] = [
            .init(id: .with(intValue: 1), name: "1", location: "1l", duration: 1, storageType: .local),
            .init(id: .with(intValue: 2), name: "2", location: "2l", duration: 2, storageType: .remote),
        ]
        await sut._setLoadedRecords(activityRecords)
        #expect(sut.loadedRecords == activityRecords)

        await sut.filterChanged()
        #expect(sut.records == expectedFormattedModels)
    }

    @Test
    @MainActor
    func sut_should_navigate_to_add_record_on_add_tapped() async throws {
        Container.shared.recordCoordinator.register {
            RecordCoordinatorSpy()
        }

        let spy = try #require(Container.shared.recordCoordinator() as? RecordCoordinatorSpy)
        let sut = RecordListViewModel()
        await sut.onAddTapped()

        #expect(spy.spiablePath == [.addRecord])
    }
}

private extension RecordListViewModel {
    func _setFilter(_ filter: FilterType) async {
        selectedFilter = filter
    }

    func _setLoadedRecords(_ records: [ActivityRecord]) async {
        loadedRecords = records
    }
}
