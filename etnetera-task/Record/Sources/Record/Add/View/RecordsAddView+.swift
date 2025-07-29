//
//  RecordsAddView+.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

// TODO: Do localizations instead
extension StorageType {
    var title: String {
        switch self {
        case .local:
            return LocalizationKeys.Record.StorageType.local
        case .remote:
            return LocalizationKeys.Record.StorageType.remote
        }
    }
}
