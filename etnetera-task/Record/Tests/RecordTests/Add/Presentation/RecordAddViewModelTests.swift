//
//  RecordAddViewModelTests.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Factory
import FactoryTesting
import Foundation
import Testing

@testable import Record

@Suite(.container)
struct RecordAddViewModelTests {
    @Test(arguments: testFormValidityInputs)
    @MainActor
    func test_form_validity(
        formInput: RecordAddViewModel.FormInput,
        isValid: Bool
    ) async throws {
        let sut = RecordAddViewModel()
        sut.formInput = formInput
        #expect(sut.isFormValid == isValid)
    }

    @Test
    @MainActor
    func test_sut_should_save_record_and_pop_back_on_save() async throws {
        let mockedInput: RecordAddViewModel.FormInput = .validInputForActivityRecordMock
        let expectedNewRecord: ActivityRecord = .mock()

        Container.shared.recordCoordinator.register {
            let spy = RecordCoordinatorSpy()
            spy.startWithPath(path: [.recordsList, .addRecord])
            return spy
        }
        Container.shared.uuidGenerator.register {
            { UUID.with(intValue: 0) }
        }
        Container.shared.gatewayRecordListRepository.register {
            .mock(saveRecord: { record in
                #expect(record == expectedNewRecord)
                return.success(())
            } )
        }
        let spy = try #require(Container.shared.recordCoordinator() as? RecordCoordinatorSpy)

        let sut = RecordAddViewModel()
        sut.formInput = mockedInput
        await sut.saveRecord()
        await sut.savingTask?.value
        #expect(spy.spiablePath == [.recordsList])
    }

    @Test(
        arguments: [
            (RecordAddViewModel.FormInput.defaultValues, LocalizationKeys.AddRecord.Error.validation),
            (RecordAddViewModel.FormInput.validInputForActivityRecordMock, LocalizationKeys.AddRecord.Error.server),
        ]
    )
    @MainActor
    func sut_should_show_error_on_fail_and_hide_after_some_time(
        formInput: RecordAddViewModel.FormInput,
        message: String
    ) async throws {
        Container.shared.gatewayRecordListRepository.register {
            .mock(saveRecord: { _ in return .failure(.repositoryError) } )
        }
        let clock = TestClock()
        Container.shared.clock.register {
            clock
        }
        let sut = RecordAddViewModel()
        sut.formInput = formInput
        let refreshTask = Task {
            await sut.saveRecord()
        }

        await refreshTask.value
        await clock.advance(by: .seconds(0.1))
        #expect(sut.errorMessage == message)

        await clock.advance(by: .seconds(2))
        #expect(sut.errorMessage == nil)
    }

    @Test
    @MainActor
    func test_sut_should_not_save_when_in_progress() async throws {
        Container.shared.gatewayRecordListRepository.register {
            .mock(saveRecord: { _ in fatalError("Save should not be called")})
        }
        let sut = RecordAddViewModel()
        sut.formInput = .validInputForActivityRecordMock
        sut.isLoading = true
        await sut.saveRecord()
    }
}

private extension RecordAddViewModel.FormInput {
    func mutated(_ mutate: (inout Self) -> Void) -> Self {
        var copy = self
        mutate(&copy)
        return copy
    }

    static var validInputForActivityRecordMock: Self {
        let activityRecordMock: ActivityRecord = .mock()
        return .init(
            name: activityRecordMock.name,
            location: activityRecordMock.location,
            hours: 0,
            minutes: 0,
            seconds: 1,
            selectedStorageType: .local
        )
    }
}

private extension RecordAddViewModelTests {
    static var testFormValidityInputs: [(RecordAddViewModel.FormInput, Bool)] {
        [
            (RecordAddViewModel.FormInput.defaultValues, false),
            (RecordAddViewModel.FormInput.defaultValues.mutated { $0.name = "Test" }, false),
            (RecordAddViewModel.FormInput.defaultValues.mutated { $0.hours = 1 }, false),
            (RecordAddViewModel.FormInput.defaultValues.mutated { $0.location = "Place" }, false),
            (
                RecordAddViewModel.FormInput.defaultValues.mutated {
                    $0.name = "Valid"
                    $0.location = "Here"
                    $0.minutes = 5
                    $0.selectedStorageType = .local
                },
                true
            ),
            (
                RecordAddViewModel.FormInput.defaultValues.mutated {
                    $0.name = "Valid"
                    $0.location = "There"
                    $0.seconds = 30
                    $0.selectedStorageType = .remote
                },
                true
            ),
            (
                RecordAddViewModel.FormInput.defaultValues.mutated {
                    $0.name = "N"
                    $0.location = "L"
                },
                false
            )
        ]
    }
}
