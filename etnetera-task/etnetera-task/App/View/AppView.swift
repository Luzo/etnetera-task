//
//  AppView.swift
//  etnetera-task
//
//  Created by Lubos Lehota on 25/07/2025.
//

import SwiftUI

@main
struct AppView: App {
    // TODO: injection?
    @Bindable private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            // NOTE: Needs to be revisited, but point is to be able to navigate within the feature
            // - maybe a rename would be beneficial as well to Records or something closer to domain encapsulation
            NavigationStack(path: $coordinator.navigationPath) {
                LaunchView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .recordsList:
                            // TODO: split to new view
                            VStack {
                                Spacer()

                                Button("Add record") {
                                    coordinator.navigate(to: .addRecord)
                                }
                            }
                            .navigationBarBackButtonHidden()
                        case .addRecord:
                            EmptyView()
                        }
                    }
            }
            .onAppear {
                coordinator.navigate(to: .recordsList)
            }
        }
    }
}
