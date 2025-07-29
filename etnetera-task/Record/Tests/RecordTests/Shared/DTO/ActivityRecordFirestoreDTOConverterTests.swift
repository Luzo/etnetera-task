//
//  ActivityRecordFirestoreDTOConverterTests.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import Testing

@testable import Record

struct ActivityRecordFirestoreDTOConverterTests {
    @Test
    func sut_should_convert_from_domain() {
        let sut = ActivityRecordFirestoreDTOConverter.live
        let mock = SendableActivityRecordDTO.mock()
        let converted = sut.fromDomain(mock)
        #expect(converted == .init(id: mock.id, name: mock.name, location: mock.location, duration: mock.duration))
    }

    @Test
    func sut_should_convert_from_domain_or_fail_or_return_conversion_error() {
        let sut = ActivityRecordFirestoreDTOConverter.live
        let expectedResult = SendableActivityRecordDTO.mock()
        let mock = ActivityRecordFirestoreDTO(
            id: expectedResult.id,
            name: expectedResult.name,
            location: expectedResult.location,
            duration: expectedResult.duration
        )
        let converted = sut.toDomain(mock)
        #expect(converted == expectedResult)
    }
}
