//
//  RecordCoordinatorSpy.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

@testable import Record
import SwiftUI

final class RecordCoordinatorSpy {
    private let coordinator = RecordCoordinator()
    var spiablePath: [RecordFeature.Route] = []

    func startWithPath(path: [RecordFeature.Route]) {
        path.forEach(navigate(to:))
    }
}

extension RecordCoordinatorSpy: RecordCoordinatorProtocol {
    var navigationPath: NavigationPath {
        get {
            coordinator.navigationPath
        } set {
            coordinator.navigationPath = newValue
        }
    }

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
