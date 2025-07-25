//
//  RecordsListView.swift
//  etnetera-task
//
//  Created by Lubos Lehota on 25/07/2025.
//

import SwiftUI

struct RecordListView: View {
    // TODO: inject coordinator instead
    private let onAddRecordTap: () -> Void

    init(onAddRecordTap: @escaping () -> Void) {
        self.onAddRecordTap = onAddRecordTap
    }

    var body: some View {
        VStack {
            Spacer()

            Button("Add record") {
                onAddRecordTap()
            }
        }
    }
}
