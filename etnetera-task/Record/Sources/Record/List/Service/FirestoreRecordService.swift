//
//  FirestoreRecordService.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

actor FirestoreRecordService: RemoteRecordService{
    private var records: [ActivityRecord] = []

    func loadRecords() async -> Result<[ActivityRecord], RemoteRecordServiceError> {
        .failure(.serverError)
    }

    func saveRecord(_ record: ActivityRecord) async -> Result<Void, RemoteRecordServiceError> {
        .failure(.serverError)
    }
}
