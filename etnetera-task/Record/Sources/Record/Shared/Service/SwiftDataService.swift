//
//  SwiftDataService.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import Factory
import Foundation
import SwiftData

actor SwiftDataService: OnDeviceRecordService {
    @Injected(\.swiftDataContainer) var container
    @Injected(\.activityRecordSwiftDataConverter) var converter
    @Injected(\.userIDService) var userIDService

    func loadRecords() async -> Result<[SendableActivityRecordDTO], OnDeviceRecordServiceError> {
        let context = ModelContext(container)

        return await loadSwiftDataRecords(in: context)
            .mapSuccess { [converter] in $0.map(converter.toDomain) }
    }

    func saveRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, OnDeviceRecordServiceError> {
        let context = ModelContext(container)
        do {
            let user = await createUserIfNonExistentOrReturn(withID: userIDService.userID, in: context)
            let model = converter.fromDomain(record)
            model.user = user
            context.insert(model)
            try context.save()
            return .success(())
        } catch {
            return .failure(.serviceError)
        }
    }

    func deleteRecord(_ record: SendableActivityRecordDTO) async -> Result<Void, OnDeviceRecordServiceError> {
        let context = ModelContext(container)

        guard
            let records = await loadSwiftDataRecords(in: context).successOrNil,
            let recordToRemove = records.first(where: { $0.id == record.id })
        else {
            return .failure(.serviceError)
        }
        context.delete(recordToRemove)

        do {
            try context.save()
        } catch {
            return .failure(.serviceError)
        }

        return .success(())
    }
}

// NOTE: It would be nice to have this separately - for time sake won't be done
extension SwiftDataService {
    func createUserIfNonExistentOrReturn(withID userID: String, in context: ModelContext) async -> UserSwiftDataDTO? {
        if let existingUser = await fetchUser(withID: userID, in: context) {
            return existingUser
        }

        let model = UserSwiftDataDTO(id: userID)
        context.insert(model)
        return model
    }

    func fetchUser(withID userID: String, in context: ModelContext) async -> UserSwiftDataDTO? {
        let descriptor = FetchDescriptor<UserSwiftDataDTO>(
            predicate: #Predicate<UserSwiftDataDTO> { $0.id == userID },
            sortBy: []
        )

        return try? context.fetch(descriptor).first
    }

    func loadSwiftDataRecords(in context: ModelContext) async -> Result<[ActivityRecordSwiftDataDTO], OnDeviceRecordServiceError> {
        guard let user = await fetchUser(withID: userIDService.userID, in: context) else {
            return .success([])
        }

        guard let records = try? context.fetch(FetchDescriptor<ActivityRecordSwiftDataDTO>()) else {
            return .failure(.serviceError)
        }

        return .success(
            records
                .filter { $0.user == user }
        )
    }
}

extension Container {
    var swiftDataContainer: Factory<ModelContainer> {
        Factory(self) {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            return try! ModelContainer(
                for: UserSwiftDataDTO.self, ActivityRecordSwiftDataDTO.self,
                configurations: configuration
            )
        }
        .onTest {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            return try! ModelContainer(
                for: UserSwiftDataDTO.self, ActivityRecordSwiftDataDTO.self,
                configurations: configuration
            )
        }
        .once()
        .singleton
    }
}


extension Container {
    var swiftDataService: Factory<any OnDeviceRecordService> {
        Factory(self) { SwiftDataService() }
    }
}
