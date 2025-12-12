//
//  RecordCoordinatorView.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import FactoryKit
import SwiftUI

public struct RecordCoordinatorView: View {
    @InjectedObservable(\.recordCoordinatorViewModel) var viewModel

    public init() {}

    public var body: some View {
        // TODO: this could be probably in APP, navigation Destination would stay with some extra generc protocol
        // coordinator would be passed through dependencies, thus needed in some reusable package imported everywhere
        NavigationStack(path: $viewModel.coordinator.navigationPath) {
            EmptyView()
                .navigationDestination(for: RecordFeature.Route.self) { route in
                        switch route {
                        case .recordsList:
                            RecordListView()
                                .navigationBarBackButtonHidden()
                        case .addRecord:
                            AddRecordView()
                        }
                    }
        }
        .onAppear {
            viewModel.coordinator.start()
        }
    }
}

