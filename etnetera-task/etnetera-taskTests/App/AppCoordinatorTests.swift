//
//  AppCoordinatorTests.swift
//  etnetera-taskTests
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Foundation
import Testing
import SwiftUI

@testable import etnetera_task

struct AppCoordinatorTests {

    @Test func sut_should_set_initial_route_on_start() async throws {
        // TODO: find a way to test this properly - navigation path doesn't provide any way to get the components
        let sut = AppCoordinator()
        sut.start()

        #expect(sut.navigationPath.count == 1)
    }

    @Test func sut_should_push_add_record() async throws {
        let sut = AppCoordinatorSpy()
        sut.startWithPath(path: [.recordsList])
        sut.navigate(to: .addRecord)

        #expect(sut.navigationPath.count == 2)
        #expect(sut.spiablePath.last == .addRecord)
    }

    @Test func sut_should_pop_last() async throws {
        let sut = AppCoordinatorSpy()
        sut.startWithPath(path: [.recordsList, .addRecord])
        sut.pop()

        #expect(sut.navigationPath.count == 1)
        #expect(sut.spiablePath.first == .recordsList)
    }
}

private class AppCoordinatorSpy {
    private let appCoordinator = AppCoordinator()
    var spiablePath: [Route] = []

    func startWithPath(path: [Route]) {
        path.forEach(navigate(to:))
    }
}

extension AppCoordinatorSpy: AppCoordinatorProtocol {
    var navigationPath: NavigationPath { appCoordinator.navigationPath }

    func start() {
        appCoordinator.start()
    }

    func navigate(to route: Route) {
        spiablePath.append(route)
        appCoordinator.navigate(to: route)
    }

    func pop() {
        spiablePath.removeLast()
        appCoordinator.pop()
    }
}
