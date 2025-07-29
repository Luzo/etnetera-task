//
//  View+.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import SwiftUI

extension StorageType {
    var colorText: String {
        switch self {
        case .local:
            return ColorText.local.rawValue
        case .remote:
            return ColorText.remote.rawValue
        }
    }
}

extension FilterType {
    var colorText: String? {
        switch self {
        case .all:
            return nil
        case .local:
            return ColorText.local.rawValue
        case .remote:
            return ColorText.remote.rawValue
        }
    }
}

extension FilterType {
    var title: String {
        switch self {
        case .all:
            return LocalizationKeys.Record.FilterType.all
        case .local:
            return LocalizationKeys.Record.FilterType.local
        case .remote:
            return LocalizationKeys.Record.FilterType.remote
        }
    }
}

private enum ColorText: String {
    case local = "🔵"
    case remote = "🟢"
}
