//
//  RecordAdd.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Factory
import SwiftUI

struct AddRecordView: View {
    @InjectedObservable(\.recordAddViewModel) var viewModel

    var body: some View {
        NavigationView {
            Form {
                Section("Record Details") {
                    TextField("Activity Name", text: $viewModel.formInput.name)

                    TextField("Location", text: $viewModel.formInput.location)
                }

                Section("Storage") {
                    Picker("Storage Type", selection: $viewModel.formInput.selectedStorageType) {
                        ForEach(StorageType.allCases, id: \.self) { type in
                            Text(type.title)
                                .tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section("Duration") {
                    HStack {
                        VStack {
                            Text("Hours")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Hours", selection: $viewModel.formInput.hours) {
                                ForEach(0..<24) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 100)
                        }

                        VStack {
                            Text("Minutes")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Minutes", selection: $viewModel.formInput.minutes) {
                                ForEach(0..<60) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 100)
                        }

                        VStack {
                            Text("Seconds")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Seconds", selection: $viewModel.formInput.seconds) {
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
                        Text("Save Record")
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!viewModel.isFormValid)
                }
            }
        }
        .navigationTitle("Add Record")
        .navigationBarTitleDisplayMode(.inline)
    }
}
