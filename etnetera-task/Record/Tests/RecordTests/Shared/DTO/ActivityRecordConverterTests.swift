//
//  ActivityRecordConverterTests.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Testing

@testable import Record

struct ActivityRecordConverterTests {
    @Test
    func sut_should_convert_from_domain() {
        let sut = ActivityRecordConverter.live
        let converted = sut.fromDomain(.mock())
        #expect(converted == .mock())
    }

    @Test(
        arguments: [
            (
                SendableActivityRecordDTO.mock(),
                Result<ActivityRecord, ActivityRecordConverterError>.success(.mock(storageType: .remote))
            ),
            (
                SendableActivityRecordDTO.mock(id: "a"),
                Result<ActivityRecord, ActivityRecordConverterError>.failure(.conversionError)
            )
        ]
    )
    func sut_should_convert_from_domain_or_fail_or_return_conversion_error(
        dtoToConvert: SendableActivityRecordDTO,
        expectedResult: Result<ActivityRecord, ActivityRecordConverterError>
    ) {
        let sut = ActivityRecordConverter.live
        let converted = sut.toDomain(.remote, dtoToConvert)
        #expect(converted == expectedResult)
    }
}
