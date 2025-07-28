//
//  FirestoreRecordService.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

import Factory
import FirebaseFirestore

actor FirestoreRecordService: RemoteRecordService{
    private lazy var db = Firestore.firestore()
    // TODO: inject from some safe storage upon load
    private let userID: String = "B0nXqrMe7hfndefayv86"

    func loadRecords() async -> Result<[ActivityRecordDTO], RemoteRecordServiceError> {
        do {
            let snapshot = try await db.collection("users")
                .document(userID)
                .collection("records")
                .getDocuments()

            let fetchedRecords = snapshot.documents.compactMap { doc in
                try? doc.data(as: ActivityRecordDTO.self)
            }

            return .success(fetchedRecords)
        } catch {
            return .failure(.serverError)
        }
    }

    func saveRecord(_ record: ActivityRecordDTO) async -> Result<Void, RemoteRecordServiceError> {
        do {
            let collection = db.collection("users")
                .document(userID)
                .collection("records")

            let id = record.id
            try collection.document(id).setData(from: record)

            return .success(())
        } catch {
            return .failure(.serverError)
        }
    }
}

extension Container {
    var firestoreRecordService: Factory<any RemoteRecordService> {
        Factory(self) { FirestoreRecordService() }
    }
}
