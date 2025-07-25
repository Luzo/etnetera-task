//
//  AppCoordinator.swift
//  etnetera-task
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Observation
import SwiftUI

enum Route {
    case recordsList
    case addRecord
}

protocol AppCoordinatorProtocol {
    var navigationPath: NavigationPath { get }

    func start()
    func navigate(to route: Route)
    func pop()
}

// TODO: maybe this will need to be redone - at least for now it is possible to pop to a launch view
@Observable class AppCoordinator: AppCoordinatorProtocol {
    var navigationPath = NavigationPath()

    func start() {
        navigationPath = NavigationPath()
        navigate(to: .recordsList)
    }

    func navigate(to route: Route) {
        navigationPath.append(route)
    }

    func pop() {
        navigationPath.removeLast()
    }
}
