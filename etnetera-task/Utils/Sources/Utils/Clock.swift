//
//  Clock.swift
//  Utils
//
//  Created by Lubos Lehota on 30/07/2025.
//

import Factory
import Foundation

public protocol SchedulingClock: Sendable {
    func sleep(for duration: ContinuousClock.Instant.Duration) async throws
}

struct SystemClock: SchedulingClock {
    func sleep(for duration: Duration) async throws {
        try await Task.sleep(for: duration)
    }
}

public extension Container {
    var clock: Factory<SchedulingClock> {
        Factory(self) {
            SystemClock()
        }
        .onTest {
            ImmediateClock()
        }
        .once()
    }
}

struct ImmediateClock: SchedulingClock {
    func sleep(for duration: Duration) async throws {
    }
}
