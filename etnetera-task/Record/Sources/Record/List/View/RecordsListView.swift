//
//  RecordsListView.swift
//  etnetera-task
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Factory
import SwiftUI

// TODO: Localizations
struct RecordListView: View {
    @InjectedObservable(\.recordListViewModel) var viewModel

    var body: some View {
        VStack {
            Picker("Filter", selection: $viewModel.selectedFilter) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Text(
                        [filter.colorText, filter.rawValue].compactMap { $0 }.joined(separator: "\t")
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

            List(viewModel.records) { record in
                RecordRowView(record: record)
            }
        }
        .navigationTitle("Activity Records")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.onAddTapped()
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .refreshable {
            await viewModel.onRefresh()
        }
        .task {
            await viewModel.onTask()
        }
    }
}
