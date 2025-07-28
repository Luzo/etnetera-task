//
//  RecordAddViewModel.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Factory
import Foundation

@Observable
@MainActor
class RecordAddViewModel {
    @ObservationIgnored
    @Injected(\.gatewayRecordListRepository) private var recordsRepository
    @ObservationIgnored
    @Injected(\.recordCoordinator) private var coordinator
    @ObservationIgnored
    @Injected(\.uuidGenerator) private var uuidGenerator

    var formInput: FormInput = .defaultValues
}

extension RecordAddViewModel {
    var isFormValid: Bool { formInput.isInputValid }

    @MainActor
    func saveRecord() async {
        guard isFormValid else {
            // TODO: show some message
            return
        }

        let duration = TimeInterval(formInput.hours * 3600 + formInput.minutes * 60 + formInput.seconds)
        let record = ActivityRecord(
            id: uuidGenerator(),
            name: formInput.name.trimmingCharacters(in: .whitespacesAndNewlines),
            location: formInput.location.trimmingCharacters(in: .whitespacesAndNewlines),
            duration: duration,
            storageType: formInput.selectedStorageType
        )


        switch await recordsRepository.saveRecord(record) {
        case .success:
            coordinator.pop()
        case .failure:
            // TODO: show some message on error
            break
        }
    }
}

extension Container {
    var recordAddViewModel: Factory<RecordAddViewModel> {
        Factory(self) { @MainActor in
            RecordAddViewModel()
        }
        .unique
    }
}

extension RecordAddViewModel {
    struct FormInput {
        var name: String
        var location: String
        var hours: Int
        var minutes: Int
        var seconds: Int
        var selectedStorageType: StorageType
    }
}

extension RecordAddViewModel.FormInput {
    static var defaultValues: Self {
        .init(
            name: "",
            location: "",
            hours: 0,
            minutes: 0,
            seconds: 0,
            selectedStorageType: .local
        )
    }
}

private extension RecordAddViewModel.FormInput {
    var isInputValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (hours > 0 || minutes > 0 || seconds > 0)
    }
}
