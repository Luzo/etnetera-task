//
//  RemoteRecordService+mock.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

@testable import Record

struct RemoteRecordServiceStub: RemoteRecordService {
    var loadRecords: Result<[Record.ActivityRecordDTO], Record.RemoteRecordServiceError> = .failure(.serverError)
    var saveRecords: Result<Void, Record.RemoteRecordServiceError> = .failure(.serverError)

    func saveRecord(_ record: Record.ActivityRecordDTO) async -> Result<Void, Record.RemoteRecordServiceError> {
        saveRecords
    }

    func loadRecords() async -> Result<[Record.ActivityRecordDTO], Record.RemoteRecordServiceError> {
        loadRecords
    }
}
