//
//  UUIDGenerator.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import Factory
import Foundation

public typealias UUIDGenerator = () -> UUID

public extension Container {
    var uuidGenerator: Factory<UUIDGenerator> {
        Factory(self) {
            { UUID() }
        }
    }
}
