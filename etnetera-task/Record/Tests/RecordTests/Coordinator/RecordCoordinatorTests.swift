//
//  RecordCoordinatorTests.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import SwiftUI
import Testing
@testable import Record

struct RecordCoordinatorTests {
    @Test
    func sut_should_set_initial_route_on_start() async throws {
        // TODO: find a way to test this properly - navigation path doesn't provide any way to get the components
        let sut = RecordCoordinatorSpy()
        sut.start()

        #expect(sut.navigationPath.count == 1)
    }

    @Test
    func sut_should_push_add_record() async throws {
        let sut = RecordCoordinatorSpy()
        sut.startWithPath(path: [.recordsList])
        sut.navigate(to: .addRecord)

        #expect(sut.navigationPath.count == 2)
        #expect(sut.spiablePath.last == .addRecord)
    }

    @Test
    func sut_should_pop_last() async throws {
        let sut = RecordCoordinatorSpy()
        sut.startWithPath(path: [.recordsList, .addRecord])
        sut.pop()

        #expect(sut.navigationPath.count == 1)
        #expect(sut.spiablePath.first == .recordsList)
    }
}

private class RecordCoordinatorSpy {
    private let coordinator = RecordCoordinator()
    var spiablePath: [RecordFeature.Route] = []

    func startWithPath(path: [RecordFeature.Route]) {
        path.forEach(navigate(to:))
    }
}

extension RecordCoordinatorSpy: RecordCoordinatorProtocol {
    var navigationPath: NavigationPath { coordinator.navigationPath }

    func start() {
        coordinator.start()
    }

    func navigate(to route: RecordFeature.Route) {
        spiablePath.append(route)
        coordinator.navigate(to: route)
    }

    func pop() {
        spiablePath.removeLast()
        coordinator.pop()
    }
}
