//
//  ListContentView.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import SwiftUI

struct ListContentView: View {
    var isLoading: Bool
    var records: [FormattedActivityRecord]

    var deleteAction: (FormattedActivityRecord) -> Void


    init(isLoading: Bool, records: [FormattedActivityRecord], deleteAction: @escaping (FormattedActivityRecord) -> Void) {
        self.isLoading = isLoading
        self.records = records
        self.deleteAction = deleteAction
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

         if records.isEmpty {
             ScrollView {
                  VStack {
                      Spacer(minLength: 100)

                      Image(systemName: "figure.run")
                          .font(.system(size: 30))
                          .foregroundColor(.black)

                      Text(LocalizationKeys.RecordList.No.Records.found)
                          .font(.headline)
                          .foregroundColor(.black)

                      Spacer()
                  }
                  .frame(maxWidth: .infinity)
              }
            } else {
                List(records) { record in
                    RecordRowView(record: record)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteAction(record)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .redacted(reason: isLoading ? .placeholder : [])
            }
        }
    }
}
