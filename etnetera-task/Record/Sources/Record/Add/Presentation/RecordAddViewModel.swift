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
    @ObservationIgnored
    @Injected(\.clock) private var clock

    @ObservationIgnored
    var savingTask: Task<Void, Never>?

    var formInput: FormInput = .defaultValues
    var isLoading: Bool = false
    var errorMessage: String?
}

extension RecordAddViewModel {
    var isFormValid: Bool { formInput.isInputValid }

    @MainActor
    func saveRecord() async {
        savingTask = Task {
            guard !isLoading else { return }
            defer { isLoading = false }
            isLoading = true

            guard isFormValid else {
                showDisappearingError(withMessage: LocalizationKeys.AddRecord.Error.validation)
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

            if Task.isCancelled { return }
            let results = await recordsRepository.saveRecord(record)
            if Task.isCancelled { return }

            switch results {
            case .success:
                coordinator.pop()
            case .failure:
                showDisappearingError(withMessage: LocalizationKeys.AddRecord.Error.server)
                break
            }
        }
    }

    func onDisappear() async {
        savingTask?.cancel()
    }

    private func showDisappearingError(withMessage message: String) {
        Task {
            errorMessage = message
            try? await clock.sleep(for: .seconds(2))
            errorMessage = nil
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
