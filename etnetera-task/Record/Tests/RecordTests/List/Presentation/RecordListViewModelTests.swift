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
private struct RecordListViewModelTests {
    @Test
    @MainActor
    func sut_should_load_records_on_refresh() async throws {
        let expectedRecords = ActivityRecord.mocks
        Container.shared.gatewayRecordListRepository.register {
            .mock(loadRecords: { _ in return .success(expectedRecords) } )
        }
        let sut = RecordListViewModel()

        #expect(sut.loadedRecords.isEmpty)

        let refreshTask = Task {
            await sut.onRefresh()
        }

        await refreshTask.value
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

        let onTask = Task {
            await sut.onTask()
        }

        await onTask.value

        #expect(sut.loadedRecords == ActivityRecord.mocks)
    }

    @Test(.serialized, arguments: testWipeActiveFilterResultsInputs)
    @MainActor
    func sut_should_only_wipe_active_filter_results_on_reload(
        input: TestWipeActiveFilterResultsInput
    ) async throws {
        Container.shared.gatewayRecordListRepository.register {
            .mock(loadRecords: { _ in return .success([input.newRecord]) } )
        }
        let sut = RecordListViewModel()
        await sut._setFilter(input.filter)
        await sut._setLoadedRecords(input.storedRecords)

        await sut.onRefresh()
        #expect(sut.loadedRecords == input.newStoredRecords)
    }

    @Test(.serialized, arguments: testOnFilterChangedInputs)
    @MainActor
    func sut_should_filter_records_on_filter_changed(
        selectedFilter: FilterType,
        expectedFormattedModels: [FormattedActivityRecord]
    ) async throws {
        let sut = RecordListViewModel()
        await sut._setLoadedTypes([.local, .remote])
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

// FIXME: there seems to be some issue with test clock randomly blocking main-thread
//    @Test
//    @MainActor
//    func sut_should_show_error_on_fail_and_hide_after_some_time() async throws {
//        Container.shared.gatewayRecordListRepository.register {
//            .mock(loadRecords: { _ in return .failure(.repositoryError) } )
//        }
//        let clock = TestClock()
//        Container.shared.clock.onTest {
//            clock
//        }
//        let sut = RecordListViewModel()
//
//        let refreshTask = Task {
//            await sut.onRefresh()
//        }
//
//        await clock.advance(by: .seconds(0.3))
//
//        await refreshTask.value
//        #expect(sut.errorMessage != nil)
//
//        await clock.advance(by: .seconds(2))
//        #expect(sut.errorMessage == nil)
//    }

    @Test
    @MainActor
    func sut_should_remove_record() async throws {
        await confirmation { confirmation in
            Container.shared.gatewayRecordListRepository.register {
                .mock(deleteRecord: { _ in
                    confirmation.confirm()
                    return .success(()) }
                )
            }
            let sut = RecordListViewModel()
            sut.loadedRecords = ActivityRecord.mocks
            await sut.onDeleteTapped(recordID: sut.loadedRecords[0].id.uuidString)
        }
    }

// FIXME: there seems to be some issue with test clock randomly blocking main-thread
//
//    @Test
//    func sut_should_show_reachability_error_on_fail_and_hide_after_some_time() async throws {
//        let clock = TestClock()
//
//        Container.shared.clock.onTest {
//            clock
//        }
//        let reachability = StubNetworkReachabilityService()
//        Container.shared.networkReachabilityService.onTest {
//            reachability
//        }
//
//        await reachability._setStatus(isConnected: false)
//
//        let sut = await RecordListViewModel()
//
//        let refreshTask = await MainActor.run {
//            Task {
//                await sut.onRefresh()
//            }
//        }
//
//        await refreshTask.value
//        await clock.advance(by: .seconds(0.3))
//        await #expect(sut.errorMessage == LocalizationKeys.RecordList.No.Network.error)
//
//        await clock.advance(by: .seconds(2))
//        await #expect(sut.errorMessage == nil)
//    }
}

private extension RecordListViewModel {
    func _setFilter(_ filter: FilterType) async {
        selectedFilter = filter
    }

    func _setLoadedRecords(_ records: [ActivityRecord]) async {
        loadedRecords = records
    }

    func _setLoadedTypes(_ types: [StorageType]) async {
        loadedTypes = types
    }
}

private extension StubNetworkReachabilityService {
    func _setStatus(isConnected: Bool) async {
        self.isConnected = isConnected
    }
}

private extension RecordListViewModelTests {
    static var testOnFilterChangedInputs: [(FilterType, [FormattedActivityRecord])] {
        [
            (
                FilterType.all,
                [
                    FormattedActivityRecord(
                        id: UUID.with(intValue: 1).uuidString,
                        name: "1",
                        location: "1l",
                        duration: "0:01",
                        storageType: .local
                    ),
                    FormattedActivityRecord(
                        id: UUID.with(intValue: 2).uuidString,
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
                        id: UUID.with(intValue: 1).uuidString,
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
                        id: UUID.with(intValue: 2).uuidString,
                        name: "2",
                        location: "2l",
                        duration: "0:02",
                        storageType: .remote
                    ),
                ]
            )
        ]
    }

    struct TestWipeActiveFilterResultsInput {
        let filter: FilterType
        let newRecord: ActivityRecord
        let storedRecords: [ActivityRecord]
        let newStoredRecords: [ActivityRecord]
    }

    static var testWipeActiveFilterResultsInputs: [TestWipeActiveFilterResultsInput] {
        let localMock: ActivityRecord = .mock(uuid: .with(intValue: 1), storageType: .local)
        let remoteMock: ActivityRecord = .mock(uuid: .with(intValue: 0), storageType: .remote)
        let previousRecords: [ActivityRecord] = [localMock, remoteMock]
        let newResult: ActivityRecord = .mock(uuid: .with(intValue: 2))

        return [
            .init(
                filter: .all,
                newRecord: newResult,
                storedRecords: previousRecords,
                newStoredRecords: [newResult]
            ),
            .init(
                filter: .local,
                newRecord: newResult,
                storedRecords: previousRecords,
                newStoredRecords: [remoteMock] + [newResult]
            ),
            .init(
                filter: .remote,
                newRecord: newResult,
                storedRecords: previousRecords,
                newStoredRecords: [localMock] + [newResult]
            )
        ]
    }
}
