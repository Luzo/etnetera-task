//
//  RemoteRecordService+mock.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

@testable import Record

struct RemoteRecordServiceStub: RemoteRecordService {
    var loadRecords: Result<[SendableActivityRecordDTO], RemoteRecordServiceError> = .failure(.serverError)
    var saveRecords: Result<Void, RemoteRecordServiceError> = .failure(.serverError)
    var deleteRecord: Result<Void, RemoteRecordServiceError> = .failure(.serverError)

    func saveRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, RemoteRecordServiceError> {
        saveRecords
    }

    func loadRecords() async -> Result<[SendableActivityRecordDTO], RemoteRecordServiceError> {
        loadRecords
    }

    func deleteRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, RemoteRecordServiceError> {
        deleteRecord
    }
}
