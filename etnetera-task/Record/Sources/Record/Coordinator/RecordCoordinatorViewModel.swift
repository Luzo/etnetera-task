//
//  RecordCoordinatorViewModel.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import FactoryKit
import SwiftUI

@Observable
class RecordCoordinatorViewModel {
    @ObservationIgnored
    @Injected(\.recordCoordinator) var coordinator
}

extension Container {
    var recordCoordinatorViewModel: Factory<RecordCoordinatorViewModel> {
        Factory(self) {
            RecordCoordinatorViewModel()
        }
        .unique
    }
}
