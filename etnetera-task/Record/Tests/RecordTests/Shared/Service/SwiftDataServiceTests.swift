//
//  SwiftDataServiceTests.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import Factory
import FactoryTesting
import Foundation
import SwiftData
import Testing

@testable import Record

@Suite(.container)
struct SwiftDataServiceTests {
    @Test
    @MainActor
    func sut_should_save_and_load_records() async {
        let userIDService = UserIDService()
        Container.shared.userIDService.register { userIDService }

        let expectedRecord: SendableActivityRecordDTO = .mock()
        let sut = SwiftDataService()

        let savedResult = await sut.saveRecord(expectedRecord)
        #expect(savedResult.failureOrNil == nil)

        let result = await sut.loadRecords()
        #expect(result.successOrNil == [expectedRecord])

        let otherUserID = UUID.with(intValue: 5).uuidString
        await userIDService._setUserID(otherUserID)

        let otherUserResult = await sut.loadRecords()
        #expect(otherUserResult.successOrNil == [])
    }
}

private extension UserIDService {
    func _setUserID(_ userID: String) {
        self.userID = userID
    }
}
