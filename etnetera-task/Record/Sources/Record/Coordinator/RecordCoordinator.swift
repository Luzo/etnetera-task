//
//  RecordCoordinator.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Observation
import SwiftUI

enum RecordFeature {
    enum Route {
        case recordsList
        case addRecord
    }
}

protocol RecordCoordinatorProtocol {
    var navigationPath: NavigationPath { get }

    func start()
    func navigate(to route: RecordFeature.Route)
    func pop()
}

@Observable
class RecordCoordinator: RecordCoordinatorProtocol {
    var navigationPath = NavigationPath()

    func start() {
        navigationPath = NavigationPath()
        navigate(to: .recordsList)
    }

    func navigate(to route: RecordFeature.Route) {
        navigationPath.append(route)
    }

    func pop() {
        navigationPath.removeLast()
    }
}
