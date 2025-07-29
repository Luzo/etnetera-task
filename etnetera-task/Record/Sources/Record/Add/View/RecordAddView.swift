import Factory
import SwiftUI

struct AddRecordView: View {
    @InjectedObservable(\.recordAddViewModel) var viewModel

    var body: some View {
        NavigationView {
            Form {
                Section(LocalizationKeys.AddRecord.RecordDetails.Section.title) {
                    TextField(LocalizationKeys.AddRecord.ActivityName.Textfield.placeholder, text: $viewModel.formInput.name)

                    TextField(LocalizationKeys.AddRecord.Location.Textfield.placeholder, text: $viewModel.formInput.location)
                }

                Section(LocalizationKeys.AddRecord.Storage.Section.title) {
                    Picker(
                        LocalizationKeys.AddRecord.StorageType.Picker.title,
                        selection: $viewModel.formInput.selectedStorageType
                    ) {
                        ForEach(StorageType.allCases, id: \.self) { type in
                            Text(type.title)
                                .tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(LocalizationKeys.AddRecord.Duration.Section.title) {
                    HStack {
                        VStack {
                            Text(LocalizationKeys.AddRecord.Duration.Hours.label)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker(
                                LocalizationKeys.AddRecord.Duration.Hours.label,
                                selection: $viewModel.formInput.hours
                            ) {
                                ForEach(0..<24) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 100)
                        }

                        VStack {
                            Text(LocalizationKeys.AddRecord.Duration.Minutes.label)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker(
                                LocalizationKeys.AddRecord.Duration.Minutes.label,
                                selection: $viewModel.formInput.minutes
                            ) {
                                ForEach(0..<60) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 100)
                        }

                        VStack {
                            Text(LocalizationKeys.AddRecord.Duration.Seconds.label)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker(
                                LocalizationKeys.AddRecord.Duration.Seconds.label,
                                selection: $viewModel.formInput.seconds
                            ) {
                                ForEach(0..<60) { second in
                                    Text("\(second)").tag(second)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 100)
                        }
                    }
                }

                Section {
                    Button {
                        Task {
                            await viewModel.saveRecord()
                        }
                    } label: {
                        Text(LocalizationKeys.AddRecord.SaveRecord.Button.title)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!viewModel.isFormValid)
                }
            }
        }
        .navigationTitle(LocalizationKeys.AddRecord.Navigation.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
