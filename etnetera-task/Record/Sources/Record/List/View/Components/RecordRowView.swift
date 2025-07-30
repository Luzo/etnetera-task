//
//  RecordRowView.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import SwiftUI

struct RecordRowView: View {
    let record: FormattedActivityRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.name)
                    .font(.headline)

                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text(record.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text(record.duration)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack {
                Text(record.storageType.colorText)
            }
        }
        .padding(.vertical, 4)
    }
}
