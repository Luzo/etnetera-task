//
//  TestClock.swift
//  Record
//
//  Created by Lubos Lehota on 30/07/2025.
//

import Utils

actor TestClock: SchedulingClock {
    private var now: Duration = .zero
    private var sleepers: [(resumeAt: Duration, continuation: CheckedContinuation<Void, Never>)] = []

    func sleep(for duration: Duration) async throws {
        await withCheckedContinuation { continuation in
            let wakeTime = now + duration
            sleepers.append((resumeAt: wakeTime, continuation: continuation))
        }
    }

    func advance(by duration: Duration) async {
        // NOTE: this is here to give scheduler time to schedule Task
        try? await Task.sleep(for: .microseconds(100))

        now += duration
        let ready = sleepers.filter { $0.resumeAt <= now }
        sleepers.removeAll { $0.resumeAt <= now }

        for sleeper in ready {
            sleeper.continuation.resume()
        }

        await Task.yield()
    }
}
