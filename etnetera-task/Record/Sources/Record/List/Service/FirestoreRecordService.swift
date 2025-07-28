//
//  FirestoreRecordService.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

import Factory

actor FirestoreRecordService: RemoteRecordService{
    private var records: [ActivityRecord] = []

    func loadRecords() async -> Result<[ActivityRecord], RemoteRecordServiceError> {
        .failure(.serverError)
    }

    func saveRecord(_ record: ActivityRecord) async -> Result<Void, RemoteRecordServiceError> {
        .failure(.serverError)
    }
}

extension Container {
    var firestoreRecordService: Factory<some RemoteRecordService> {
        Factory(self) { FirestoreRecordService() }
    }
}
