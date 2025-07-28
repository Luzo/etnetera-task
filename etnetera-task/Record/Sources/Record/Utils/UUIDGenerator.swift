//
//  UUIDGenerator.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Factory
import Foundation

typealias UUIDGenerator = () -> UUID

extension Container {
    var uuidGenerator: Factory<UUIDGenerator> {
        Factory(self) {
            { UUID() }
        }
    }
}
