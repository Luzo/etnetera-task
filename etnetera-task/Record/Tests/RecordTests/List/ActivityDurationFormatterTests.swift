//
//  ActivityDurationFormatterTests.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Foundation
import Testing

@testable import Record

struct ActivityDurationFormatterTests {
    @Test(
        arguments: [
            (1, "0:01"),
            (3601, "1:00:01")
        ]
    )
    func sut_should_format_time_correctly(
        input: TimeInterval,
        output: String,
    ) async throws {
        let sut =  ActivityDurationFormatter()
        #expect(sut.formattedDuration(input) == output)
    }
}
