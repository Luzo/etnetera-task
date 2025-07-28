//
//  ActivityRecord.swift
//  Record
//
//  Created by Lubos Lehota on 25/07/2025.
//

import Foundation

enum StorageType: CaseIterable {
    case local
    case remote
}

struct ActivityRecord: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let location: String
    let duration: TimeInterval
    let storageType: StorageType
}
