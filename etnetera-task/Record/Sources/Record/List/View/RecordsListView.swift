//
//  RecordsListView.swift
//  etnetera-task
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Factory
import SwiftUI

struct RecordListView: View {
    @InjectedObservable(\.recordListViewModel) var viewModel

    var body: some View {
        VStack {
            Picker(LocalizationKeys.RecordList.Filter.Picker.title, selection: $viewModel.selectedFilter) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Text(
                        [filter.colorText, filter.title].compactMap { $0 }.joined(separator: "\t")
                    )
                    .tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: viewModel.selectedFilter) { _, _ in
                Task {
                    await viewModel.filterChanged()
                }
            }

            ListContentView(
                isLoading: viewModel.isLoading,
                records: viewModel.isLoading ? FormattedActivityRecord.placeholders : viewModel.records
            )
        }
        .navigationTitle(LocalizationKeys.RecordList.Navigation.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.onAddTapped()
                    }
                } label: {
                    Image(systemName: "plus")
                        .accessibilityLabel(LocalizationKeys.RecordList.Toolbar.Button.add)
                }
            }
        }
        .refreshable {
            await Task {
                await viewModel.onRefresh()
            }.value
        }
        .task {
            await viewModel.onTask()
        }
        .overlay(
            Group {
                if let message = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        SnackbarView(message: message)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)
                }
            }
        )
    }
}


private extension FormattedActivityRecord {
    static var placeholders: [FormattedActivityRecord] {
        (0..<3).map { id in
            FormattedActivityRecord(
                id: "\(id)",
                name: "Lorem ipsum",
                location: "Lorem ipsum dolor sit amet",
                duration: "0:01",
                storageType: .local
            )
        }
    }
}
