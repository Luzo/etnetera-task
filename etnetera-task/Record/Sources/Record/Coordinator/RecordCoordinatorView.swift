//
//  RecordCoordinatorView.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import SwiftUI

public struct RecordCoordinatorView: View {
    // TODO: injection?
    @Bindable private var coordinator: RecordCoordinator

    public init() {
        coordinator = RecordCoordinator()
    }

    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            EmptyView()
                .navigationDestination(for: RecordFeature.Route.self) { route in
                        switch route {
                        case .recordsList:
                            RecordListView(
                                onAddRecordTap: {
                                    coordinator.navigate(to: .addRecord)
                                }
                            )
                            .navigationBarBackButtonHidden()
                        case .addRecord:
                            EmptyView()
                        }
                    }
        }
        .onAppear {
            coordinator.start()
        }
    }
}

