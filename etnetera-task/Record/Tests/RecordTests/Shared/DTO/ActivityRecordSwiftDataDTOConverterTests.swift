//
//  ActivityRecordSwiftDataDTOConverterTests.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import Testing

@testable import Record

struct ActivityRecordSwiftDataDTOConverterTests {
    @Test
    func sut_should_convert_from_domain() {
        let sut = ActivityRecordSwiftDataDTOConverter.live
        let mock = SendableActivityRecordDTO.mock()
        let converted = sut.fromDomain(mock)
        #expect(converted.id == mock.id)
        #expect(converted.name == mock.name)
        #expect(converted.location == mock.location)
        #expect(converted.duration == mock.duration)
    }

    @Test
    func sut_should_convert_from_domain_or_fail_or_return_conversion_error() {
        let sut = ActivityRecordSwiftDataDTOConverter.live
        let expectedResult = SendableActivityRecordDTO.mock()
        let mock = ActivityRecordSwiftDataDTO(
            id: expectedResult.id,
            name: expectedResult.name,
            location: expectedResult.location,
            duration: expectedResult.duration
        )
        let converted = sut.toDomain(mock)
        #expect(converted == expectedResult)
    }
}
