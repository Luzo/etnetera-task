//
//  UUID+intInit.swift
//  Record
//
//  Created by Lubos Lehota on 26/07/2025.
//

import Foundation

extension UUID {
    static func with(intValue: Int) -> Self {
        let valueText = "\(intValue)"
        let length = valueText.count
        let text = String(repeating: "0", count: 32-length) + valueText

        guard let uuidText = text.formatAsUUID(), let uuid = UUID(uuidString: uuidText) else {
            // TODO: move and make throwable
            fatalError()
        }

        return uuid
    }
}

extension String {
    func formatAsUUID() -> String? {
        let cleaned = replacingOccurrences(of: "-", with: "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard cleaned.count == 32 else { return nil }

        let indices = [8, 12, 16, 20]
        var lastIndex = cleaned.startIndex
        var parts = [String]()

        for index in indices {
            let nextIndex = cleaned.index(cleaned.startIndex, offsetBy: index)
            parts.append(String(cleaned[lastIndex..<nextIndex]))
            lastIndex = nextIndex
        }

        parts.append(String(cleaned[lastIndex...]))

        return parts.joined(separator: "-")
    }
}

