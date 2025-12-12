//
//  ActivityDurationFormatter.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import FactoryKit
import Foundation

struct ActivityDurationFormatter {
    func formattedDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

extension Container {
    var activityDurationFormatter: Factory<ActivityDurationFormatter> {
        Factory(self) { ActivityDurationFormatter() }
    }
}
