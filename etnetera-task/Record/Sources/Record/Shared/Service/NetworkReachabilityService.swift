//
//  NetworkReachabilityService.swift
//  Record
//
//  Created by Lubos Lehota on 30/07/2025.
//

import FactoryKit
import Network

// NOTE: There is a bug in the system - when wifi reconnects simulator doesn't get a notification
// https://www.reddit.com/r/swift/comments/ir8wn5/network_connectivity_is_always_unsatisfied_when/
actor NetworkReachabilityService: ReachabilityService {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")

    private var isConnected: Bool = false

    func isConnected() async -> Bool {
        isConnected
    }

    init() {
        Task {
            await startMonitoring()
        }
    }

    private func startMonitoring() async {
        let stream = AsyncStream<Bool> { continuation in
            monitor.pathUpdateHandler = { path in
                continuation.yield(path.status == .satisfied)
            }

            monitor.start(queue: queue)

            continuation.onTermination = { @Sendable [weak self] _ in
                self?.monitor.cancel()
            }

            continuation.yield(monitor.currentPath.status == .satisfied)
        }

        Task {
            for await connected in stream {
                await updateConnectionStatus(connected)
            }
        }
    }

    private func updateConnectionStatus(_ connected: Bool) async {
        print("Network status update: \(connected ? "connected" : "disconnected")")
        isConnected = connected
    }
}

actor StubNetworkReachabilityService: ReachabilityService {
    var isConnected: Bool = true

    func isConnected() async -> Bool { isConnected }
}

extension Container {
    var networkReachabilityService: Factory<ReachabilityService> {
        Factory(self) { NetworkReachabilityService() }
            .onTest { StubNetworkReachabilityService() }
            .once()
            .singleton
    }
}
