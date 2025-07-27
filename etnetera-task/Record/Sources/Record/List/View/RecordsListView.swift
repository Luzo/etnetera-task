//
//  RecordsListView.swift
//  etnetera-task
//
//  Created by Lubos Lehota on 25/07/2025.
//

import SwiftUI

// TODO: Localizations
struct RecordListView: View {
    // TODO: inject coordinator instead
    private let onAddRecordTap: () -> Void
    @Bindable private var viewModel: RecordListViewModel = .init()

    init(onAddRecordTap: @escaping () -> Void) {
        self.onAddRecordTap = onAddRecordTap
    }

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
                    onAddRecordTap()
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
