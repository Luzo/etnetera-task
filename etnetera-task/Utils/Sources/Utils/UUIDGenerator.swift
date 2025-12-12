//
//  UUIDGenerator.swift
//  Record
//
//  Created by Lubos Lehota on 28/07/2025.
//

import FactoryKit
import Foundation

public typealias UUIDGenerator = () -> UUID

public extension Container {
    var uuidGenerator: Factory<UUIDGenerator> {
        Factory(self) {
            { UUID() }
        }
    }
}
