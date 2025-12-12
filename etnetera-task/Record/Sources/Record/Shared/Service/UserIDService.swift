//
//  UserIDService.swift
//  Record
//
//  Created by Lubos Lehota on 29/07/2025.
//

import FactoryKit

// TODO: This could be dynamic and stored in Keychain
actor UserIDService {
    var userID: String = "B0nXqrMe7hfndefayv86"
}

extension Container {
    var userIDService: Factory<UserIDService> {
        Factory(self) { UserIDService() }
    }
}
