//
//  FirestoreRecordService.swift
//  Record
//
//  Created by Lubos Lehota on 27/07/2025.
//

import Factory
import FirebaseFirestore

actor FirestoreRecordService: RemoteRecordService {
    @Injected(\.activityRecordFirestoreConverter) var converter
    @Injected(\.userIDService) var userIDService
    private lazy var db = Firestore.firestore()

    func loadRecords() async -> Result<[SendableActivityRecordDTO], RemoteRecordServiceError> {
        let snapshot = try? await db.collection("users")
            .document(userIDService.userID)
            .collection("records")
            .getDocuments()

        guard let snapshot else { return .failure(.serverError) }

        let fetchedRecords = snapshot.documents
            .compactMap { doc in try? doc.data(as: ActivityRecordFirestoreDTO.self) }
            .map(converter.toDomain)

        return .success(fetchedRecords)

    }

    func saveRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, RemoteRecordServiceError> {
        do {
            let collection = await db.collection("users")
                .document(userIDService.userID)
                .collection("records")

            let id = record.id
            try collection.document(id).setData(from: converter.fromDomain(record))

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
