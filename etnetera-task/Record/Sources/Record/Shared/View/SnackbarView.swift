//
//  SnackbarView.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import SwiftUI

struct SnackbarView: View {
    let message: String

    var body: some View {
        HStack {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .background(Color.red.opacity(0.8))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
